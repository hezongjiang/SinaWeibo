//
//  WebViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/22.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    private lazy var webView: UIWebView = {
        let wb = UIWebView(frame: UIScreen.main.bounds)
        wb.delegate = self
        wb.scrollView.contentInset.top = 64
        wb.scrollView.subviews.first?.backgroundColor = UIColor.white
        return wb
    }()
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
            view.insertSubview(webView, belowSubview: navigationBar)
        }
    }
    
    override func setupTableView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    deinit {
        print("xiaohui")
    }
}

extension BaseViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        navItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
    }
}
