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

var playerNumber: Int = 0

class SankasyaViewControllerTableViewController: UITableViewController{
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90.0;
        self.navigationItem.title = "参加者"

        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        print(players)
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem()
        print("playerNumber is \(playerNumber)")
        
    }
    
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
                shift_player.id = self.players[i+1].id - 1
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
        print("selected \(indexPath.row)")
        playerNumber = indexPath.row
        print("aaaaaaplayerNumber is \(playerNumber)")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let viewController:UIViewController = segue.destinationViewController
//        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
//        let player = players[tableView.indexPathForSelectedRow!.row]
//        //let xarray = (Array<Int>)(1...Int(player.point_list.count))
//        var xarray = [String]()
//        var yarray = [CGFloat]()
//        
//        for (var i=0;i<player.point_list.count;i++){
//            xarray.append("\(i+1)")
//        }
//        
//        for (var j=0;j<player.point_list.count;j++){
//            yarray.append(CGFloat(player.point_list[j].point))
//        }
//        
//        ChartLabel.textColor = PNGreenColor
//        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
//        ChartLabel.textAlignment = NSTextAlignment.Center
//        //Add LineChart
//        ChartLabel.text = "\(players[tableView.indexPathForSelectedRow!.row].name)"
//        
//        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 135.0, 320, 200.0))
////        lineChart.yLabelFormat = "%f"
//        lineChart.showLabel = true
//        lineChart.backgroundColor = UIColor.clearColor()
//        lineChart.xLabels = xarray
//        lineChart.showCoordinateAxis = true
//        lineChart.delegate = self
//        
//        // Line Chart Nr.1
//        let data01Array: [CGFloat] = yarray
//        let data01:PNLineChartData = PNLineChartData()
//        data01.color = PNGreenColor
//        data01.itemCount = data01Array.count
//        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
//        data01.getData = ({(index: Int) -> PNLineChartDataItem in
//            let yValue:CGFloat = data01Array[index]
//            let item = PNLineChartDataItem(y: yValue)
//            return item
//        })
//        
//        lineChart.chartData = [data01]
//        lineChart.strokeChart()
//        
//        //lineChart.delegate = self
//        
//        viewController.view.addSubview(lineChart)
//        viewController.view.addSubview(ChartLabel)
//        viewController.title = "Line Chart"
    
//        case "barChart":
//            //Add BarChart
//            ChartLabel.text = "Bar Chart"
//            
//            var barChart = PNBarChart(frame: CGRectMake(0, 135.0, 320.0, 200.0))
//            barChart.backgroundColor = UIColor.clearColor()
//            //            barChart.yLabelFormatter = ({(yValue: CGFloat) -> NSString in
//            //                var yValueParsed:CGFloat = yValue
//            //                var labelText:NSString = NSString(format:"%1.f",yValueParsed)
//            //                return labelText;
//            //            })
//            
//            
//            // remove for default animation (all bars animate at once)
//            barChart.animationType = .Waterfall
//            
//            
//            barChart.labelMarginTop = 5.0
//            barChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
//            barChart.yValues = [1,24,12,18,30,10,21]
//            barChart.strokeChart()
//            
//            barChart.delegate = self
//            
//            viewController.view.addSubview(ChartLabel)
//            viewController.view.addSubview(barChart)
//            
//            viewController.title = "Bar Chart"
//            
//        default:
//            print("Hello Chart")
//        }
        
//    }
//    
//    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
//    {
//        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
//    }
//    
//    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
//    {
//        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
//    }
//    
//    func userClickedOnBarChartIndex(barIndex: Int)
//    {
//        print("Click  on bar \(barIndex)")
//    }
    
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
