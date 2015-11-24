//
//  KekkaViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift

class KekkaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var players = [Player]()
    var player1number = Int()
    var player2number = Int()
    var player3number = Int()
    var player4number = Int()
    
    // Toolbar
    private var doneToolbar: UIToolbar!
    @IBOutlet var point1: UITextField!
    @IBOutlet var point2: UITextField!
    @IBOutlet var point3: UITextField!
    @IBOutlet var point4: UITextField!
    @IBOutlet var rate: UITextField!
    @IBOutlet weak var player1Table: UITableView!
    @IBOutlet weak var player2Table: UITableView!
    @IBOutlet weak var player3Table: UITableView!
    @IBOutlet weak var player4Table: UITableView!
    @IBOutlet weak var player1btn: UIButton!
    @IBOutlet weak var player2btn: UIButton!
    @IBOutlet weak var player3btn: UIButton!
    @IBOutlet weak var player4btn: UIButton!

    @IBAction func player1btnAction(sender: AnyObject) {
        player1Table.hidden = !player1Table.hidden
    }
    
    @IBAction func player2btnAction(sender: AnyObject) {
        player2Table.hidden = !player2Table.hidden
    }
    
    @IBAction func player3btnAction(sender: AnyObject) {
        player3Table.hidden = !player4Table.hidden
    }
    
    @IBAction func player4btnAction(sender: AnyObject) {
        player4Table.hidden = !player4Table.hidden
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "結果";
        super.viewDidLoad()
        let realm = try! Realm()
        players = realm.objects(Player).map{$0}
        //PlayerTableView
        player1Table.delegate = self
        player2Table.delegate = self
        player3Table.delegate = self
        player4Table.delegate = self
        player1Table.dataSource = self
        player2Table.dataSource = self
        player3Table.dataSource = self
        player4Table.dataSource = self
        player1Table.hidden = true
        player2Table.hidden = true
        player3Table.hidden = true
        player4Table.hidden = true
        //--- add UIToolBar on keyboard and Done button on UIToolBar ---//
        self.addDoneButtonOnKeyboard()
        point1.placeholder = "player1"
        point2.placeholder = "player2"
        point3.placeholder = "player3"
        point4.placeholder = "player4"
        rate.placeholder = "rate"
        point1.keyboardType = UIKeyboardType.NumbersAndPunctuation
        point2.keyboardType = UIKeyboardType.NumbersAndPunctuation
        point3.keyboardType = UIKeyboardType.NumbersAndPunctuation
        point4.keyboardType = UIKeyboardType.NumbersAndPunctuation
        rate.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }
    
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        point1.inputAccessoryView = doneToolbar
        point2.inputAccessoryView = doneToolbar
        point3.inputAccessoryView = doneToolbar
        point4.inputAccessoryView = doneToolbar
        rate.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        point1.resignFirstResponder()
        point2.resignFirstResponder()
        point3.resignFirstResponder()
        point4.resignFirstResponder()
        rate.resignFirstResponder() 
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        players = realm.objects(Player).map{$0}
        player1Table.reloadData()
        player2Table.reloadData()
        player3Table.reloadData()
        player4Table.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(players.count == 0){
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "No Player"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }else{
            let cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "\(players[indexPath.row].name)"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
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
        }else if(tableView == player3Table){
            player3btn.setTitle("\(players[indexPath.row].name)", forState: UIControlState.Normal)
            player3number = indexPath.row
            player3Table.hidden = true
        }else if(tableView == player4Table){
            player4btn.setTitle("\(players[indexPath.row].name)", forState: UIControlState.Normal)
            player4number = indexPath.row
            player4Table.hidden = true
        }else{
        }
    }
    
    @IBAction func resultButton(sender: UIButton) {
        let doublepoint1:Double = NSString(string: point1.text!).doubleValue
        let doublepoint2:Double = NSString(string: point2.text!).doubleValue
        let doublepoint3:Double = NSString(string: point3.text!).doubleValue
        let doublepoint4:Double = NSString(string: point4.text!).doubleValue
        let doublerate = NSString(string: rate.text!).doubleValue
        let result1 = doublepoint1 * doublerate
        let result2 = doublepoint2 * doublerate
        let result3 = doublepoint3 * doublerate
        let result4 = doublepoint4 * doublerate
        let pointTextFields: [UITextField] = [point1, point2, point3, point4]
        let results = pointTextFields.map { NSString(string: $0.text!).doubleValue * doublerate }
        
        let players_order = ["\(player1btn.currentTitle!)","\(player2btn.currentTitle!)","\(player3btn.currentTitle!)","\(player4btn.currentTitle!)"]
        let set = NSOrderedSet(array: players_order)
        let result_order = set.array as! [String]

        let sum = results.reduce(0, combine: +)        
        
        if sum != 0 {
            let alertController = UIAlertController(title: "Alert", message: "Sum of points is not 0!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(doublerate == 0){
            let alertController = UIAlertController(title: "Alert", message: "Rate is not filled!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if player1btn.currentTitle! == "Player1" || player2btn.currentTitle! == "Player2" || player3btn.currentTitle! == "Player3" || player4btn.currentTitle! == "Player4" {
            let alertController = UIAlertController(title: "Alert", message: "Players are not filled!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(result_order.count != 4){
            let alertController = UIAlertController(title: "Alert", message: "Players are overlapped!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "Congratulations!", message: "1st:\(player1btn.currentTitle!)...\(Int(result1*100.0))\n2nd:\(player2btn.currentTitle!)...\(Int(result2*100.0))\n3rd\(player3btn.currentTitle!)...\(Int(result3*100.0))\n4th:\(player4btn.currentTitle!)...\(Int(result4*100.0))", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }

        let tensu1 = Points()
        let tensu2 = Points()
        let tensu3 = Points()
        let tensu4 = Points()
        let juni1 = Ranks()
        let juni2 = Ranks()
        let juni3 = Ranks()
        let juni4 = Ranks()
        tensu1.point = Int(self.point1.text!)!
        tensu2.point = Int(self.point2.text!)!
        tensu3.point = Int(self.point3.text!)!
        tensu4.point = Int(self.point4.text!)!
        juni1.rank = 1
        juni2.rank = 2
        juni3.rank = 3
        juni4.rank = 4
        let realm = try! Realm()
        try! realm.write{
            self.players[self.player1number].money += Int(result1*100)
            self.players[self.player1number].point_list.append(tensu1)
            self.players[self.player1number].rank_list.append(juni1)
            self.players[self.player2number].money += Int(result2*100)
            self.players[self.player2number].point_list.append(tensu2)
            self.players[self.player2number].rank_list.append(juni2)
            self.players[self.player3number].money += Int(result3*100)
            self.players[self.player3number].point_list.append(tensu3)
            self.players[self.player3number].rank_list.append(juni3)
            self.players[self.player4number].money += Int(result4*100)
            self.players[self.player4number].point_list.append(tensu4)
            self.players[self.player4number].rank_list.append(juni4)
        }
    }
}
    

