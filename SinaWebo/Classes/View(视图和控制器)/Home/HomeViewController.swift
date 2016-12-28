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

    lazy var statusList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    /// 重写父类的“加载数据”
    override func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

            
            for i in 0...20 {
                
                if self.isPullup {
                    
                    self.statusList.append("上拉" + "\(i)")
                } else {
                    
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            self.tableView?.reloadData()
            self.refreshController?.endRefreshing()
            self.isPullup = false
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

}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = statusList[indexPath.row]
        return cell!
    }
}
