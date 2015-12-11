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
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        if let ref = self.refreshControl {
            self.tableView.addSubview(ref)
        }
        
        
        
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        
        fetch_player(tableView)
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    func refresh()
    {
        fetch_player(tableView)
        self.refreshControl?.endRefreshing()
    }
    
//    func save_players(){
//        let realm = try! Realm()
//        players = realm.objects(Player).map { $0 }
//        let query: PFQuery = PFQuery(className: "realms")
//        query.orderByAscending("createdAt")
//        
//        for p in players {
//            let pp = PFObject(className: "realms")
//            
//            pp["order"] = p.order
//            pp["name"] = p.name
//            pp["money"] = p.money
//            pp["rank_list"] = p.rank_list.map { $0.rank }
//            pp["point_list"] = p.point_list.map { $0.point }
//            
//            try! pp.save()
//            
//            try! realm.write {
//                p.identifier = pp.objectId!
//            }
//            
//            pp["identifier"] = pp.objectId!
//            
//            try! pp.save()
//        }
//    }
    
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
    
    func fetch_player(tableVew: UITableView) {
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        players = realm.objects(Player).map { $0 }
        let query: PFQuery = PFQuery(className: "realms")
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            for object in objects! {
                if(error == nil){
                    let player = Player()
                    for (var i=0;i<object["rank_list"].count;i++){
                        let r = Ranks()
                        r.rank = object["rank_list"][i] as! Int
                        try! realm.write{
                            player.rank_list.append(r)
                        }
                    }
                    
                    for (var i=0;i<object["point_list"].count;i++){
                        let p = Points()
                        p.point = object["point_list"][i] as! Int
                        try! realm.write{
                            player.point_list.append(p)
                        }
                    }
                    
                    try! realm.write{
                        player.order = object["order"] as! Int
                        player.name = object["name"] as! String
                        player.money = object["money"] as! Int
                        player.identifier = object["identifier"] as! String
                    }
                    
                    
                    try! realm.write{
                        realm.add(player)
                    }
                }
            }
            self.players = realm.objects(Player).map { $0 }
            self.tableView.reloadData()
        }
        return
    }
    
//    func update_players(){
//        let realm = try! Realm()
//        players = realm.objects(Player).map { $0 }
//        let query: PFQuery = PFQuery(className: "realms")
//        query.orderByAscending("createdAt")
//        
//        query.getObjectInBackgroundWithId(players[0].identifier){ (object, error) -> Void in
//            
//            print(object)
//
////        for p in self.players {
////            var pp = PFObject(className: "realms")
//            
////            print(query.getObjectInBackgroundWithId(p.identifier))
//            
////            pp["order"] = p.order
////            pp["name"] = p.name
////            pp["money"] = p.money
////            pp["rank_list"] = p.rank_list.map { $0.rank }
////            pp["point_list"] = p.point_list.map { $0.point }
////            
////            try! pp.save()
////            
////            try! realm.write {
////                p.identifier = pp.objectId!
////            }
////            }
//        }
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
            let findPlayer: PFQuery = PFQuery(className: "realms")
            do {
                let p = try findPlayer.getObjectWithId(self.players[indexPath.row].identifier)
                try! p.delete()
            }
            catch {
                print("invalide identifier")
            }
            try! realm.write {
                realm.delete(self.players[self.players.count-1])
            }
            players = realm.objects(Player).map { $0 }
            self.tableView.reloadData()
        }else{
            let findPlayer: PFQuery = PFQuery(className: "realms")
            for(var i = indexPath.row; i <= Int(self.players.count)-2; i++) {
                let shift_player = Player()
                shift_player.name = self.players[i+1].name
                shift_player.order = self.players[i+1].order - 1
                shift_player.money = self.players[i+1].money
                try! realm.write {
                    realm.add(shift_player, update: true)
                }
                let sp = try! findPlayer.getObjectWithId(self.players[i+1].identifier)
                sp["order"]  = (sp["order"] as! Int) - 1
                try! sp.save()
            }
            
            do {
                let p = try findPlayer.getObjectWithId(self.players[indexPath.row].identifier)
                try! p.delete()
            }
            catch {
                print("invalide identifier")
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
                
                let findPlayer: PFQuery = PFQuery(className: "realms")
                findPlayer.orderByDescending("order")
                let newplayer = Player()
                
                do {
                   newOrder = (try findPlayer.getFirstObject()["order"] as! Int!) + 1
                }
                catch {
                    newOrder = 0
                }
//                if let lastOrder = try! findPlayer.getFirstObject()["order"] as? Int {
//                    newOrder = lastOrder + 1
//                } else {
//                    newOrder = 0
//                }
                
                print("newOder", newOrder)
                
                newplayer.name = inputTextField!.text!
                newplayer.money = 0
                newplayer.order = newOrder
                newplayer.point_list.appendContentsOf([])
                newplayer.rank_list.appendContentsOf([])
                
                try! realm.write {
                    realm.add(newplayer)
                }
                
                let query: PFQuery = PFQuery(className: "realms")
                query.orderByAscending("createdAt")
                let pp = PFObject(className: "realms")
                
                pp["order"] = newplayer.order
                pp["name"] = newplayer.name
                pp["money"] = newplayer.money
                pp["rank_list"] = newplayer.rank_list.map { $0.rank }
                pp["point_list"] = newplayer.point_list.map { $0.point }
                
                try! pp.save()
                
                try! realm.write {
                    newplayer.identifier = pp.objectId!
                }
                
                pp["identifier"] = pp.objectId!
                
                try! pp.save()
                
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
