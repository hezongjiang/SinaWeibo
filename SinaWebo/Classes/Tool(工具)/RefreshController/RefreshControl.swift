//
//  RefreshController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/11.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

private let refreshOffset: CGFloat = 60


/// 刷新状态
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点，但还没放手
/// - WillRefresh: 超过临界点，且已经放手
enum RefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/// 自定义刷新控件
class RefreshControl: UIControl {
    
    /// 父视图应该是一个scrollview
    var scrollView: UIScrollView?
    
    /// 刷新视图
    fileprivate lazy var refreshView: RefreshView = RefreshView.refreshView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    /// 在添加到父视图时，添加监听方法
    override func willMove(toSuperview newSuperview: UIView?) {
        
        guard let sv = newSuperview as? UIScrollView else { return }
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // KVO监听scrollView的下拉
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else { return }
        
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        
        if height < 0 { return }
        
        frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if sv.isDragging { // 表格正在拖拽
            
            if height > refreshOffset && refreshView.refreshState == .Normal {
                
                refreshView.refreshState = .Pulling
                
            } else if height < refreshOffset && refreshView.refreshState == .Pulling {
                
                refreshView.refreshState = .Normal
            }
        } else if refreshView.refreshState == .Pulling { // 表格松手拖拽，并且松手的位置超过刷新临界点
            
            beginRefreshing()
            
            sendActions(for: .valueChanged)
        }
        
    }
    
    // 移除KVO监听
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
        guard let sv = scrollView, refreshView.refreshState != .WillRefresh else { return }
        
//        if refreshView.refreshState == .WillRefresh { return }
        
        refreshView.refreshState = .WillRefresh
        
        sv.contentInset.top += refreshOffset
        
        print("开始刷新")
    }
    
    /// 结束刷新
    func endRefreshing() {
        
        print("结束刷新")
        
        if refreshView.refreshState != .WillRefresh { return }
        
        refreshView.refreshState = .Normal
        
        scrollView?.contentInset.top -= refreshOffset
        
    }
}

extension RefreshControl {
    
    fileprivate func setupUI() {
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(refreshView)
        
        // 添加自动布局
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: refreshView.bounds.height))
        
        backgroundColor = superview?.backgroundColor
    }
}
