//
//  SQLiteManager.swift
//  FMDBDemo
//
//  Created by Hearsay on 2017/2/6.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit
import FMDB

/// 最大缓存时间
private let maxDBcacheTime: TimeInterval = -5 * 60 * 60 * 24

/// 数据库管理者
class SQLiteManager: NSObject {
    
    static let manager = SQLiteManager()
    
    fileprivate let queue: FMDatabaseQueue
    
    private override init() {
        
        let dbName = "status.db"
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径: \(path)")
        
        // 创建数据库队列，同时创建或打开数据库
        queue = FMDatabaseQueue(path: path)
        
        super.init()
        
        createTable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func clearCache() {
        
        let dateString = Date.dateString(dalte: maxDBcacheTime)
        
        print("清理缓存\(dateString)")
        
        let sql = "DELETE FROM T_Status WHERE create_time < '\(dateString)'"
        
        queue.inDatabase { (db) in
            if db?.executeUpdate(sql, withArgumentsIn: []) == true {
                print("delete success")
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SQLiteManager {
    
    /// 创表
    fileprivate func createTable() {
        
        queue.inDatabase { (db) in
            /*
             CREATE TABLE IF NOT EXISTS T_Status (
                 statusId INTEGER NOT NULL,
                 userId INTEGER NOT NULL,
                 status TEXT,
                 create_time TEXT DEFAULT (datetime('now', 'localtime')),
                 PRIMARY KEY(statusId, userId)
             );
             */
            if db?.executeStatements("CREATE TABLE IF NOT EXISTS \"T_Status\" (\"statusId\" INTEGER NOT NULL, \"userId\" INTEGER NOT NULL, \"status\" TEXT, \"create_time\" TEXT DEFAULT (datetime('now', 'localtime')), PRIMARY KEY(\"statusId\", \"userId\"));") == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
    }
    
    
    /// 更新数据库
    func updataStatus(userId: String, status: [[String : Any]]) {
        
        queue.inTransaction { (db, rollback) in
            
            for dict in status {
                
                guard let statusId = dict["idstr"] as? String, let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else { continue }
                
                let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
                
                // 若更新数据失败
                if db?.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    // 回滚
                    rollback?.pointee = true
                    break
                }
                
            }
        }
    }
    
    /// 查询数据库
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 字典数组
    private func executeQuery(sql: String) -> [[String : Any]] {
        
        // 结果数组
        var array = [[String : Any]]()
        
        queue.inDatabase { (db) in
            
            guard let result = db?.executeQuery(sql, withArgumentsIn: []) else { return }
            
            // 下一条
            while result.next() {
                
                var dict = [String : Any]()
                
                let colCount = result.columnCount()
                
                for col in 0..<colCount {
                    
                    guard let name = result.columnName(for: col), let value = result.object(forColumnIndex: col) else { continue }
                    
                    dict[name] = value
                }
                array.append(dict)
            }
        }
        return array
    }
    
    /// 从数据库中加载微博数据
    /// 这里的参数，应该参考网络请求，看网络请求需要什么样的参数，为的是在之后的加载数据时，与网络参数相同
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String : Any]] {
        /*
         SELECT statusId, userId, status FROM T_Status WHERE userId = 1 AND statusId < 100 ORDER BY statusId DESC LIMIT 20
         */
        
        var statusId: String = ""
        
        if since_id > 0 {
            statusId = "AND statusId > \(since_id)"
        } else if max_id > 0 {
            statusId = "AND statusId < \(max_id)"
        }
        
        // 拼接sql语句
        let sql = "SELECT statusId, userId, status FROM T_Status WHERE userId = \(userId) \(statusId) ORDER BY statusId DESC LIMIT 20"
        
        let array = executeQuery(sql: sql)
        
        var result = [[String : Any]]()
        
        // 遍历查询结果
        for dict in array {
            
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] else { continue }
            
            result.append(json ?? [:])
        }
        
        return result
    }
}
