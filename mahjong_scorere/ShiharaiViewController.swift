//
//  SiharaiViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift

class SiharaiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var players = [Player]()
    var player1number: Int = 0
    var player2number: Int = 0
    
    private var doneToolbar: UIToolbar!
    @IBOutlet var point: UITextField!
    @IBOutlet weak var player1Table: UITableView!
    @IBOutlet weak var player2Table: UITableView!
    @IBOutlet weak var player1btn: UIButton!
    @IBOutlet weak var player2btn: UIButton!
    @IBOutlet weak var paybtn: UIButton!
    
    @IBAction func player1btnAction(sender: AnyObject) {
        player1Table.hidden = !player1Table.hidden
    }
    
    @IBAction func player2btnAction(sender: AnyObject) {
        player2Table.hidden = !player2Table.hidden
    }
    
    @IBAction func paybtnAction(sender: AnyObject) {
        let realm = try! Realm()
        try! realm.write{
            
            self.players[self.player1number].money -= Int(self.point.text!)!
            self.players[self.player2number].money += Int(self.point.text!)!
        }
        let alertController = UIAlertController(title: "Thank you!", message: "\(players[player1number].name) paid \(point.text!) to \(players[player2number].name)!", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        self.navigationItem.title = "支払";
        super.viewDidLoad()
        let realm = try! Realm()
        players = realm.objects(Player).map{$0}
        
        //PlayerTableView
        player1Table.delegate = self
        player2Table.delegate = self
        player1Table.dataSource = self
        player2Table.dataSource = self
        player1Table.hidden = true
        player2Table.hidden = true
        self.addDoneButtonOnKeyboard()
        point.placeholder = "How much?"
        point.keyboardType = .NumbersAndPunctuation
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        point.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        point.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        player1Table.reloadData()
        player2Table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(players.count == 0){
            return 1
        }else{
            return Int(players.count)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(players.count == 0){
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "No Player"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            return cell
        }else{
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "\(players[indexPath.row].name)"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if(tableView == player1Table){
            player1btn.setTitle("\(players[indexPath.row].name)", forState: UIControlState.Normal)
            player1number = indexPath.row
            player1Table.hidden = true
        }else if(tableView == player2Table){
            player2btn.setTitle("\(players[indexPath.row].name)", forState: UIControlState.Normal)
            player2number = indexPath.row
            player2Table.hidden = true
        }else{
        }
    }
}

