//
//  BaseViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController {
    
    /// 自定义导航栏
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    /// 自定义导航项
    lazy var navItem = UINavigationItem()
    /// 表格视图
    var tableView: UITableView?
    /// 刷新控件
    var refreshController: UIRefreshControl?
    /// 是否为上拉加载
    var isPullup = false
    /// 是否登录
    var userLogin = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupUI()
        loadData()
    }
    
    /// 加载数据
    func loadData() {
        refreshController?.endRefreshing()
    }
    
    /// 设置界面
    func setupUI() {
        
        view.backgroundColor = UIColor.cz_random()
        
        setupNav()
        
        userLogin ? setupTableView() : setupVisitor()
    }
    
    
    /// 访客视图
    private func setupVisitor() {
        
        let visitorView = VisitorView(frame: view.bounds)
        
        visitorView.backgroundColor = UIColor.cz_random()
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
    }
    
    
    /// 设置导航栏
    private func setupNav() {
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
    }
    
    /// 设置表格
    private func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        refreshController = UIRefreshControl()
        refreshController?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView?.addSubview(refreshController!)
    }
    
    @objc private func register() {
        print("注册")
    }
    
    @objc private func login() {
        print("登录")
    }
    
    /// 重新标题
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        let count = tableView.numberOfRows(inSection: section) - 1
        
        if row < 0 || section < 0 || count < 0 { return }
        
        if row == count && !isPullup {
            print("上拉加载")
            isPullup = true
            loadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
