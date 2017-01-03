//
//  OAuthViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/3.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        webView.scrollView.bounces = false
        title = "登录"
        webView.delegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(RedirectUrl)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
    
    @objc private func autoFill() {
        
        let js = "document.getElementById('userId').value = '13250231442'; " +
        "document.getElementById('passwd').value = 'huyali520';"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }

    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
}

extension OAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.url?.absoluteString ?? ""
        print("请求URL = " + urlString)
        
        if urlString.hasPrefix(RedirectUrl) {
            
            if request.url?.query?.hasPrefix("code") == true {
                
                let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
                
                // 使用授权码换区access_token
                NetworkManager.shared.loadAccessToken(code: code, completion: { (isSuccess) in
                    
                    isSuccess ? SVProgressHUD.showSuccess(withStatus: "登录成功！") : SVProgressHUD.showError(withStatus: "网络错误，登录失败！")
                })
                
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
