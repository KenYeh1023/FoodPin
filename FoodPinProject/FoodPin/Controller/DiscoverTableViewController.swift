//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/26.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    enum Section {
        case all
    }
    
    var restaurants: [CKRecord] = []
    
    lazy var dataSource = configureDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
//        Task.init(priority: .high) {
//            do {
//                try await fetchRecordsFromCloud()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        fetchRecordsFromCloud()
        tableView.dataSource = dataSource
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section,CKRecord> {
        
        let cellIdentifier: String = "discovercell"
        
        let dataSource = UITableViewDiffableDataSource<Section,CKRecord>(tableView: tableView) { (tableView, indexPath, restaurant) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = restaurant.object(forKey: "name") as? String
            
            if let image = restaurant.object(forKey: "image"), let imageAsset = image as? CKAsset {
                if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                    cell.imageView?.image = UIImage(data: imageData)
                }
            }
            
            return cell
        }
        return dataSource
    }
    
//    func fetchRecordsFromCloud() async throws {
//        let cloudContainer = CKContainer.default()
    func fetchRecordsFromCloud() {
        let cloudContainer = CKContainer(identifier: "iCloud.com.kenyeh.FoodPin1")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
//        let results = try await publicDatabase.records(matching: query)
//        
//        for record in results.matchResults {
//            self.restaurants.append(try record.1.get())
//        }
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "image"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordMatchedBlock = {(queryID, result) -> Void in
            do {
                self.restaurants.append(try result.get())
            } catch {
                print(error)
            }
        }
        
        queryOperation.queryResultBlock = {[unowned self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                print("Successfully retrieve the data from iCloud")
                self.updateSnapshot()
            }
        }
        
        publicDatabase.add(queryOperation)
//        self.updateSnapshot()
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,CKRecord>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot)
    }
}
