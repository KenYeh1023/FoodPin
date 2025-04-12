//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 4/11/2024.
//

import UIKit
import SwiftData
import UserNotifications

protocol RestaurantDataStore: AnyObject {
    func fetchRestaurantData(searchText: String)
}

class RestaurantTableViewController: UITableViewController, RestaurantDataStore {
    
    var restaurants: [Restaurant] = []
    var searchController: UISearchController!
    
    lazy var dataSource = configureDataSource()
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurants..."
        
        tableView.tableHeaderView = searchController.searchBar
//        self.navigationItem.searchController = searchController
        
        fetchRestaurantData(searchText: "")

        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        
        navigationItem.backButtonTitle = ""
        
        title = "FoodPin"
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.compactAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
        }
        
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        prepareNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    func fetchRestaurantData(searchText: String) {
        if searchText.isEmpty {
            restaurants = RestaurantManager.shared.fetchRestaurantAll() ?? []
        } else {
            let descriptor: FetchDescriptor<Restaurant>
            let predicate = #Predicate<Restaurant> {$0.name.localizedStandardContains(searchText) || $0.location.localizedStandardContains(searchText)}
            descriptor = FetchDescriptor<Restaurant>(predicate: predicate)
            restaurants = (try? RestaurantManager.shared.mainContext.fetch(descriptor)) ?? []
        }
        
        updateSnapshot()
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
    func prepareNotification() {
        guard restaurants.count != 0 else {
            return
        }
        // 隨機選擇一間餐廳
        let randomNum = Int.random(in: 0..<restaurants.count)
        let suggestedRestaurant = restaurants[randomNum]
        
        // 建立通知
        let content = UNMutableNotificationContent()
        content.title = "FoodPin"
        content.subtitle = "今日餐廳推薦"
        content.body = "試過 \(suggestedRestaurant.name) 了嗎?\n你曾蒐藏在你的 FoodPin 清單內, 快來預約用餐吧!\n餐廳地址: \(suggestedRestaurant.location)"
        content.sound = .default
        
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
        try? suggestedRestaurant.image.jpegData(compressionQuality: 1.0)?.write(to: tempDirURL)
        
        if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
            content.attachments = [restaurantImage]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)
        //排程通知
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Notification Created!")
    }

    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        
        let cellIdentifier = "datacell"
        
        let dataSource = RestaurantDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = restaurant.image
                cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
                
                return cell
            }
        )
        
        return dataSource
    }
    
    // MARK: - UITableViewDelegate Protocol
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if searchController.isActive {
            return UISwipeActionsConfiguration()
        }
        
        // Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            RestaurantManager.shared.mainContext.delete(restaurant)
            
            do {
                try  RestaurantManager.shared.mainContext.save()
            } catch {
                print(error)
            }
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            let tableCount = RestaurantManager.shared.fetchRestaurantCount()
            self.tableView.backgroundView?.isHidden = tableCount == 0 ? false : true
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + restaurant.name
            
            let activityController: UIActivityViewController
            
            activityController = UIActivityViewController(activityItems: [defaultText, restaurant.image], applicationActivities: nil)
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
            
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action
        let favoriteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell

            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            if let restaurant = RestaurantManager.shared.fetchRestaurantById(id: self.restaurants[indexPath.row].id) {
                restaurant.isFavorite = self.restaurants[indexPath.row].isFavorite
                try? RestaurantManager.shared.mainContext.save()
            }
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Configure swipe action
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
            
        return swipeConfiguration

    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
            }
        } else if segue.identifier == "addRestaurant" {
            if let navController = segue.destination as? UINavigationController,
               let destinationController = navController.topViewController as? NewRestaurantController {
                destinationController.dataStore = self
            }
        }
    }
}

// MARK: - UISearchResultUpdating
extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        fetchRestaurantData(searchText: searchText)
    }
}
