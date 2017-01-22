//
//  WebViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/22.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
            webView.delegate = self
            webView.scrollView.contentInset.top = navigationBar.bounds.height
            view.insertSubview(webView, belowSubview: navigationBar)
        }
    }
    
    override func setupTableView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension BaseViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        navItem.title = webView.stringByEvaluatingJavaScript(from: "doucment.title")
        
    }
}
