//
//  HomeViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

private let OriginCellId = "OriginCellId"
private let RetweetedCellId = "RetweetedCellId"

class HomeViewController: BaseViewController {

    /// 数据模型
    fileprivate lazy var statusListViewModel = StatusListViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser), name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification), object: nil)
    }
    
    @objc private func showPhotoBrowser(noti: Notification) {
        
        guard let urlString = noti.userInfo?["urls"] as? [String], let ivs = noti.userInfo?["imageViews"] as? [UIImageView], let index = noti.userInfo?["selectedIndex"] as? Int else { return }
        
        let vc = PhotoBrowserController(selectedIndex: index, urls: urlString, parentImageViews: ivs)
        present(vc, animated: true, completion: nil)
    }
    
    /// 重写父类的“加载数据”
    override func loadData() {
        
        if !NetworkManager.shared.userAccount.userLogin { return }
        
        refreshController?.beginRefreshing()
        
        statusListViewModel.loadStatus(isPullup: isPullup) { (isSuccess, shuoleRefresh) in
            
            self.refreshController?.endRefreshing()
            
            self.isPullup = false
            
            if shuoleRefresh { self.tableView?.reloadData() }
        }
    }
    
    override func setupTableView() {
        
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriend))
        
        tableView?.register(UINib(nibName: "StatusNormalCell", bundle: nil), forCellReuseIdentifier: OriginCellId)
        tableView?.register(UINib(nibName: "StatusRetweetedCell", bundle: nil), forCellReuseIdentifier: RetweetedCellId)
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 100
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    private func setupNavTitle() {
        
        let title = NetworkManager.shared.userAccount.screen_name
        
        let button = TitleButton(title: title)
        button.addTarget(self, action: #selector(clickNavTitleButton(btn:)), for: .touchUpInside)
        navItem.titleView = button
    }
    
    @objc private func clickNavTitleButton(btn: TitleButton) {
        btn.isSelected = !btn.isSelected
    }
    
    @objc private func showFriend() {
        tableView?.reloadData()
        
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
        //print(indexPath.row)
        let viewModel = statusListViewModel.statusList[indexPath.row]
        
        let cellId = viewModel.status.retweeted_status == nil ? OriginCellId : RetweetedCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! StatusCell
        
        cell.viewModel = viewModel
        
        cell.delegate = self
        
        return cell
    }
    
    /// 父类必须实现，子类才能重写
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = statusListViewModel.statusList[indexPath.row]
        
        return viewModel.rowHeight
    }
}

extension HomeViewController: StatusCellDelegate {
    
    func statusCell(_ statusCell: StatusCell, didSelectedURLString string: String) {
        
        let vc = WebViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.urlString = string
        vc.navItem.title = "加载中..."
        
    }
}

