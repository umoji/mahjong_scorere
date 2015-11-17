//
//  SankasyaViewControllerTableViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift

class SankasyaViewControllerTableViewController: UITableViewController {
    var players = [Player]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90.0;
        self.navigationItem.title = "参加者"

        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 先にデータを更新する
        print("delete\(indexPath.row)")
        let realm = try! Realm()
        let player = realm.objects(Player).map { $0 }[indexPath.row]
        try! realm.write {
            realm.delete(player)
        }
        
        
        players = realm.objects(Player).map { $0 }
        
        self.tableView.reloadData()
//        if indexPath.row == self.players.count - 1 {
//            try! realm.write {
//                realm.delete(self.players[self.players.count-1])
//            }
//            self.tableView.reloadData()
//        }else{
//            for(var i = indexPath.row; i <= Int(self.players.count)-2; i++) {
//                let shift_player = Player()
//                shift_player.name = self.players[i+1].name
//                shift_player.id = self.players[i+1].id - 1
//                shift_player.money = self.players[i+1].money
//                
//                try! realm.write {
//                    realm.add(shift_player, update: true)
//                }
//            }
//            
//            try! realm.write {
//                realm.delete(self.players[self.players.count-1])
//            }
//            
//            self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if players.count == 0 {
            return 1
        }else{
            return players.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if players.count == 0 {
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "None"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
            cell.detailTextLabel?.text = "¥-----"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        } else {
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            
            cell.textLabel?.text = "\(players[indexPath.row].name)"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            if Int(players[indexPath.row].money) > 0{
                cell.detailTextLabel?.textColor = UIColor.greenColor()
            } else if Int(players[indexPath.row].money) < 0{
                cell.detailTextLabel?.textColor = UIColor.redColor()
            } else {
                cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
            cell.detailTextLabel?.text = "¥\(players[indexPath.row].money)"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return cell
        }
    }
    
    @IBAction func inputFieldBtn(sender: UIButton) {
        var inputTextField: UITextField?
        
        let alertController: UIAlertController = UIAlertController(title: "Newcomer!!", message: "Input your Name", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Pushed CANCEL")
        }
        alertController.addAction(cancelAction)
        
        let realm = try! Realm()
        let logintAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            print("Pushed Create")
            let newID: Int
            let newplayer = Player()
           
            if let lastPlayer = realm.objects(Player).sorted("id").last {
                newID = lastPlayer.id + 1
            } else {
                newID = 0
            }
            
            newplayer.name = inputTextField!.text!
            newplayer.money = 0
            newplayer.id = newID
            newplayer.point_list.appendContentsOf([])
            newplayer.rank_list.appendContentsOf([])
            
            print(self.players)
            print(newplayer)
            
            try! realm.write {
                realm.add(newplayer)
            }
            
            self.players = realm.objects(Player).map { $0 }
            
            self.tableView.reloadData()
        }
        
        alertController.addAction(logintAction)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
            textField.placeholder = "Name"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
        self.tableView.reloadData()
    }
}
