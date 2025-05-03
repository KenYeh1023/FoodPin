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
    
    var spinner = UIActivityIndicatorView()
    private var ckContainerId: String = "iCloud.com.kenyeh.FoodPin1"
    private var imageCache = NSCache<CKRecord.ID, NSURL>()

    override func viewDidLoad() {
        super.viewDidLoad()
        //下拉更新
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        // 定義 spinner auto layout contraints
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        spinner.startAnimating()
        
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
        fetchRecordsFromCloud()
        tableView.dataSource = dataSource
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section,CKRecord> {
        
        let cellIdentifier: String = "discovercell"
        
        let dataSource = UITableViewDiffableDataSource<Section,CKRecord>(tableView: tableView) { (tableView, indexPath, restaurant) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = restaurant.object(forKey: "name") as? String
            //設定 default image
            cell.imageView?.image = UIImage(systemName: "photo")
            cell.imageView?.tintColor = .black
            
            //檢查 Cache 是否已經有 images
            if let imageFileURL = self.imageCache.object(forKey: restaurant.recordID) {
                //取得 Cache images
                if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                    cell.imageView?.image = UIImage(data: imageData)
                }
            } else {
                //背景 fetch images
                //let publicDatabase = CKContainer.default().publicCloudDatabase
                let publicDatabase = CKContainer(identifier: self.ckContainerId).publicCloudDatabase
                let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
                fetchRecordsImageOperation.desiredKeys = ["image"]
                fetchRecordsImageOperation.queuePriority = .veryHigh
                
                fetchRecordsImageOperation.perRecordResultBlock = {(recordID, result) in
                    do {
                        let restaurantRecord = try result.get()
                        if let image = restaurantRecord.object(forKey: "image"),
                            let imageAsset = image as? CKAsset {
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                                DispatchQueue.main.async {
                                    cell.imageView?.image = UIImage(data: imageData)
                                    cell.setNeedsLayout()
                                }
                                //儲存 image 進 Cache
                                self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                            }
                        }
                    } catch {
                        print("Failed to get iCloud restaurant Images: \(error.localizedDescription)")
                    }
                }
                
                publicDatabase.add(fetchRecordsImageOperation)
            }
            
            return cell
        }
        return dataSource
    }
    
    @objc func fetchRecordsFromCloud() {
        let cloudContainer = CKContainer(identifier: ckContainerId)
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        //建立時間排序
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordMatchedBlock = {(recordID, result) -> Void in
            do {
                if let _ = self.restaurants.first(where: {$0.recordID == recordID}) {
                    return
                }
                
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
        // 停止 spinner & refresh
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
        if let refreshControl = self.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
        
        publicDatabase.add(queryOperation)
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,CKRecord>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot)
    }
}
