//
//  SankasyaViewControllerTableViewController.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/26.
//  Copyright (c) 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit

class SankasyaViewControllerTableViewController: UITableViewController {
    
    struct Player{
        var name: String = "" //名前
        var point: Int = 0//点数合計
    }
    
    var players:[Player] = []
    var dummy = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90.0;
        self.navigationItem.title = "参加者"

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(players.count == 0){
            return 1
        }else{
            return players.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(players.count == 0){
            var cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "None"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
            cell.detailTextLabel?.text = "¥-----"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }else{
            var cell:UITableViewCell = UITableViewCell(
                style: UITableViewCellStyle.Value1,
                reuseIdentifier:"Cell" )
            cell.textLabel?.text = "\(players[indexPath.row].name)"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            if players[indexPath.row].point>0{
                cell.detailTextLabel?.textColor = UIColor.greenColor()
            }else if players[indexPath.row].point<0{
                cell.detailTextLabel?.textColor = UIColor.redColor()
            }else{
                cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
            cell.detailTextLabel?.text = "¥\(players[indexPath.row].point)"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
    }
    
    @IBAction func inputFieldBtn(sender: UIButton) {
        var inputTextField: UITextField?
        var passwordField: UITextField?
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        let alertController: UIAlertController = UIAlertController(title: "Newcomer!!", message: "Input your Name and Points", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            println("Pushed CANCEL")
        }
        alertController.addAction(cancelAction)
        
        let logintAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            println("Pushed Create")
            self.dummy.name = inputTextField!.text
            self.dummy.point = 0
            self.players.append(self.dummy)
            
            for ( var i = 0 ; i < self.players.count ; i++ ) {
                println("players\(i):\(self.players[i].name)")
            }
                println("dummy:\(self.dummy.name)")
                appDelegate.message = self.dummy.name //appDelegateの変数を操作
                self.tableView.reloadData()
        }
        alertController.addAction(logintAction)
        
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
            textField.placeholder = "Name"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
