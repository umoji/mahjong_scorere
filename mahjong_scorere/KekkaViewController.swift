//
//  KekkaViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit

class KekkaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    struct Player{
        var name:String //名前
        var point: Int //点数
    }
    // 表示する値の配列.
    var players:[String] = []
    
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
        if(player1Table.hidden==true){
            player1Table.hidden=false
        }else{
            player1Table.hidden=true
        }
    }
    @IBAction func player2btnAction(sender: AnyObject) {
        if(player2Table.hidden==true){
            player2Table.hidden=false
        }else{
            player2Table.hidden=true
        }

    }
    @IBAction func player3btnAction(sender: AnyObject) {
        if(player3Table.hidden==true){
            player3Table.hidden=false
        }else{
            player3Table.hidden=true
        }

    }
    @IBAction func player4btnAction(sender: AnyObject) {
        if(player4Table.hidden==true){
            player4Table.hidden=false
        }else{
            player4Table.hidden=true
        }

    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "結果";
        super.viewDidLoad()
        
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
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = items as [AnyObject]
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
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        var message = appDelegate.message
        
        if(contains(players,message!)){
            println("\(players)")
            println("\(message!)")
        }else{
            players.append("\(message!)")
            println("\(players)")
            println("\(message!)")
        }
        
        players.append("\(message!)")
        println("\(players)")
        println("\(message!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(player1Table: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell(
            style: UITableViewCellStyle.Value1,
            reuseIdentifier:"Cell" )
        cell.textLabel?.text = "\(players[indexPath.row])"
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if(tableView == player1Table){
            player1btn.setTitle("\(players[indexPath.row])", forState: UIControlState.Normal)
            player1Table.hidden = true
        }else if(tableView == player2Table){
            player2btn.setTitle("\(players[indexPath.row])", forState: UIControlState.Normal)
            player2Table.hidden = true
        }else if(tableView == player3Table){
            player3btn.setTitle("\(players[indexPath.row])", forState: UIControlState.Normal)
            player3Table.hidden = true
        }else if(tableView == player4Table){
            player4btn.setTitle("\(players[indexPath.row])", forState: UIControlState.Normal)
            player4Table.hidden = true
        }else{
            
        }
    }
    
    @IBAction func resultButton(sender: UIButton) {
        var doublepoint1:Double = NSString(string: point1.text).doubleValue
        var doublepoint2:Double = NSString(string: point2.text).doubleValue
        var doublepoint3:Double = NSString(string: point3.text).doubleValue
        var doublepoint4:Double = NSString(string: point4.text).doubleValue
        var doublerate:Double = NSString(string: rate.text).doubleValue
        var result1 = doublepoint1 * doublerate
        var result2 = doublepoint2 * doublerate
        var result3 = doublepoint3 * doublerate
        var result4 = doublepoint4 * doublerate
        var players_order = ["\(player1btn.currentTitle!)","\(player2btn.currentTitle!)","\(player3btn.currentTitle!)","\(player4btn.currentTitle!)"]
        var set = NSOrderedSet(array: players_order)
        var result_order = set.array as! [String]
        
        if(doublepoint1+doublepoint2+doublepoint3+doublepoint4 != 0){
            let alertController = UIAlertController(title: "Alert", message: "Sum of points is not 0!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(doublerate == 0){
            let alertController = UIAlertController(title: "Alert", message: "Rate is not filled!! ", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(player1btn.currentTitle! == "Player1" || player2btn.currentTitle! == "Player2" || player3btn.currentTitle! == "Player3" || player4btn.currentTitle! == "Player4"){
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
            let alertController = UIAlertController(title: "Congratulations!", message: "1st:\(player1btn.currentTitle!)...\(Int(result1)*100)\n2nd:\(player2btn.currentTitle!)...\(Int(result2)*100)\n3rd\(player3btn.currentTitle!)...\(Int(result3)*100)\n4th:\(player4btn.currentTitle!)...\(Int(result4)*100)", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
