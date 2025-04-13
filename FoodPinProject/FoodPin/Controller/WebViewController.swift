//
//  WebViewController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/13.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let targetUrl = URL(string: url) {
            let request = URLRequest(url: targetUrl)
            webView.load(request)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
