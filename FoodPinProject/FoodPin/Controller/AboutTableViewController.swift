//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/13.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    enum Section {
        case feedback
        case followus
    }
    
    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }
    
    var appStoreLink: String = "https://www.apple.com/ios/app-store/"
    var feedbackLink: String = "https://github.com/KenYeh1023/FoodPin"
    
    var twitterLink: String = "https://twitter.com"
    var facebookLink: String = "https://facebook.com"
    var instagramLink: String = "https://instagram.com"
    
    var sectionContent: [[LinkItem]] = [[LinkItem]]()
    
    lazy var dataSource = configureDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleBarAppearance()
        navigationController?.navigationBar.prefersLargeTitles = true
        sectionContent = [
            [LinkItem(text: "Rate us on App Store", link: appStoreLink, image: "store"),
             LinkItem(text: "Tell us your feedback", link: feedbackLink, image: "chat")],
            
            [LinkItem(text: "Twitter", link: twitterLink, image: "twitter"),
             LinkItem(text: "Facebook", link: facebookLink, image: "facebook"),
             LinkItem(text: "Instagram", link: instagramLink, image: "instagram")]
            ]
        
        tableView.dataSource = dataSource
        updateSnapshot()
        
        
    }
    
    func setNavigationTitleBarAppearance() {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showWebView":
            if let webView = segue.destination as? WebViewController {
                if let selectedCell = self.dataSource.itemIdentifier(for: tableView.indexPathForSelectedRow!) {
                    webView.url = selectedCell.link
                }
            }
        default:
            break
        }
    }
    
    func openWithSafariViewController(indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let url = URL(string: linkItem.link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true)
        }
    }

    // MARK: - Table view data source
    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        
        let cellIdentifier = "aboutcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) { (tableView, indexPath, linkItem) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        
        return dataSource
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "showWebView", sender: self)
        case 1:
            openWithSafariViewController(indexPath: indexPath)
        default:
            break
        }
        
//        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
//            return
//        }
//        if let url = URL(string: linkItem.link) {
//            UIApplication.shared.open(url)
//        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
