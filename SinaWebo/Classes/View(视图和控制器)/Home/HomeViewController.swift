//
//  HomeViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

let cellId = "cellId"

class HomeViewController: BaseViewController {

    private lazy var statusListViewModel = StatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// 重写父类的“加载数据”
    override func loadData() {
        
        if !NetworkManager.shared.userLogin {
            return
        }
        
        statusListViewModel.loadStatus(isPullup: isPullup) { (isSuccess, shuoleRefresh) in
            
            self.refreshController?.endRefreshing()
            self.isPullup = false
            if shuoleRefresh {
                
                self.tableView?.reloadData()
            }
        }
        
        
    }
    
    
    override func setupTableView() {
        
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriend))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc private func showFriend() {
        navigationController?.pushViewController(MessageViewController(), animated: true)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = statusListViewModel.statusList[indexPath.row].text
        return cell!
    }
}

