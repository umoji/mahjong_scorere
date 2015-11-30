//
//  SankasyaViewControllerTableViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift
import PNChartSwift
import Charts
import Parse

var playerNumber: Int = 0

class SankasyaViewControllerTableViewController: UITableViewController{
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90.0;
        self.navigationItem.title = "参加者"
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        save_players()
        print(players)
//        fetch_player(0)
        
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem()        
    }
    
    func save_players(){
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        for (var i=0; i<players.count; i++){
            var rank_array:[Int] = []
            var point_array:[Int] = []
            let realmObject = PFObject(className: "realms")
            realmObject["identifier"] = ""
            realmObject["order"] = players[i].order
            realmObject["name"] = players[i].name
            realmObject["money"] = players[i].money
            for (var j=0; j<players[i].rank_list.count; j++){
                rank_array.append(players[i].rank_list[j].rank)
            }
            realmObject["rank_list"] = rank_array
            for (var k=0; k<players[i].rank_list.count; k++){
                point_array.append(players[i].point_list[k].point)
            }
            realmObject["point_list"] = point_array
            realmObject.saveInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    print("Data has been saved")
                    self.players[i].identifier = realmObject["objectId"] as! String
                }
            }
        }
    }
    
//    func loadData(callback:([PFObject]!, NSError!) -> ())  {
//        let query: PFQuery = PFQuery(className: "realms")
//        query.orderByAscending("createdAt")
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            if (error != nil){
//                // エラー処理
//            }
//            callback(objects! as [PFObject], error)
//        }
//    }
    
    func fetch_player(id: Int){
        let query: PFQuery = PFQuery(className: "realms")
        query.whereKey("objectId", containsString: "\(id)")
        query.orderByAscending("createdAt")
        
        // バックグラウンドでデータを取得
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in objects! {
                
                if(error == nil){
                    print(object)
                }
            }
        }
    }
    
//    func update_players(){
//        let realm = try! Realm()
//        players = realm.objects(Player).map { $0 }
//        let query: PFQuery = PFQuery(className: "realms")
//        query.
//        
//    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let realm = try! Realm()
        if indexPath.row == self.players.count - 1 {
            try! realm.write {
                realm.delete(self.players[self.players.count-1])
            }
            players = realm.objects(Player).map { $0 }
            self.tableView.reloadData()
        }else{
            for(var i = indexPath.row; i <= Int(self.players.count)-2; i++) {
                let shift_player = Player()
                shift_player.name = self.players[i+1].name
                shift_player.order = self.players[i+1].order - 1
                shift_player.money = self.players[i+1].money
                try! realm.write {
                    realm.add(shift_player, update: true)
                }
            }
            try! realm.write {
                realm.delete(self.players[self.players.count-1])
            }
            players = realm.objects(Player).map { $0 }
            self.tableView.reloadData()
        }
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

    override func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        performSegueWithIdentifier("toSubViewController",sender: nil)
        playerNumber = indexPath.row
    }
    @IBAction func inputFieldBtn(sender: UIButton) {
        var inputTextField: UITextField?
        var exist = false
        let realm = try! Realm()
        
        let alertController: UIAlertController = UIAlertController(title: "Newcomer!!", message: "Input your Name", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Pushed CANCEL")
        }
        alertController.addAction(cancelAction)
        
        let logintAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            print("Pushed Create")
            for (var j=0; j<self.players.count; j++){
                if (self.players[j].name == inputTextField!.text!)  {
                    exist = true
                }
            }
            if exist == false{
                let newOrder: Int
                let newplayer = Player()
                if let lastPlayer = realm.objects(Player).sorted("order").last {
                    newOrder = lastPlayer.order + 1
                } else {
                    newOrder = 0
                }
                
                newplayer.name = inputTextField!.text!
                newplayer.money = 0
                newplayer.order = newOrder
                newplayer.point_list.appendContentsOf([])
                newplayer.rank_list.appendContentsOf([])
                
                try! realm.write {
                    realm.add(newplayer)
                }
                self.players = realm.objects(Player).map { $0 }
                self.tableView.reloadData()
            }else{
//                let alertController = UIAlertController(title: "Alert", message: "The player already exist!! ", preferredStyle: .Alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                alertController.addAction(defaultAction)
            }
            
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
