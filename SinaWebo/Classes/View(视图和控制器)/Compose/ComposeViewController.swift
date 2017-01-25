//
//  ComposeViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/22.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import SVProgressHUD

class ComposeViewController: UIViewController {
    
    /// 文字视图
    @IBOutlet weak var textView: ComposeTextView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 标题视图
    @IBOutlet weak var titlelabel: UILabel!
    
    /// 工具条底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    /// 发布按钮
    fileprivate lazy var composeButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeButton)
        navigationItem.titleView = titlelabel
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: textView)
        
        textViewTextDidChange()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    /// 切换表情键盘
    @IBAction func emoticonKeyboard(_ sender: UIButton) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 200))
        textView.inputView = v
        textView.reloadInputViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 事件处理
private extension ComposeViewController {
    
    @objc func textViewTextDidChange() {
        textView.placeholderLabel.isHidden = textView.hasText
        composeButton.isHidden = !textView.hasText
    }
    
    /// 键盘通知事件
    @objc func keyboardChange(n: Notification) {
        
        guard let rect = (n.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue,
            let time = (n.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber)?.doubleValue else {
                return
        }
        
        toolbarBottomCons.constant = view.bounds.height - rect.origin.y
        
        UIView.animate(withDuration: time) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 返回
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 发微博
    @objc func composeStatus() {
        
        SVProgressHUD.show()
        
        NetworkManager.shared.postStatus(text: textView.text) { (json, isSuccess) in
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    
                    SVProgressHUD.showSuccess(withStatus: "发布成功！")
                    self.back()
                })
            } else {
                
                SVProgressHUD.showSuccess(withStatus: "发布失败！")
            }
            
        }
    }
    
}
