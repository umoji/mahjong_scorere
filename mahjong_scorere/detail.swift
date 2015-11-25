//
//  detail.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/11/20.
//  Copyright © 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class DetailViewController: UIViewController{
    var players = [Player]()
    private var doneToolbar: UIToolbar!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var playername: UITextField!
    @IBOutlet weak var playermoney: UITextField!
    @IBOutlet weak var updatebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        let player = players[playerNumber]
        playername.placeholder = "\(players[playerNumber].name)"
        playermoney.placeholder = "\(players[playerNumber].money)"
        playername.keyboardType = UIKeyboardType.NumbersAndPunctuation
        playermoney.keyboardType = UIKeyboardType.NumbersAndPunctuation
        updatebtn.layer.masksToBounds = true
        updatebtn.layer.cornerRadius = 10
        updatebtn.backgroundColor = UIColor.whiteColor()
        updatebtn.layer.borderWidth = 1
        lineChartView.descriptionText = ""
        pieChartView.descriptionText = ""
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var xarrayline = [String]()
        var yarrayline = [Double]()
        var yarraylinesum = [Double]()
        let xarraypie = ["1位", "2位", "3位", "4位"]
        var yarraypie = [0.0, 0.0, 0.0, 0.0]
        
        for (var i=0;i<player.point_list.count;i++){
            xarrayline.append("\(i+1)")
        }
        
        for (var i=0;i<player.point_list.count;i++){
            yarrayline.append(Double(player.point_list[i].point))
        }
        var sum:Double = 0.0
        for (var i=0;i<yarrayline.count;i++){
            for (var j=0;j<=i;j++){
                sum += yarrayline[j]
            }
            yarraylinesum.append(sum)
            sum = 0.0
        }
        
        for (var i=0;i<player.rank_list.count;i++){
            if player.rank_list[i].rank == 1 {
                yarraypie[0] += 1.0
            }else if player.rank_list[i].rank == 2 {
                yarraypie[1] += 1.0
            }else if player.rank_list[i].rank == 3 {
                yarraypie[2] += 1.0
            }else{
                yarraypie[3] += 1.0
            }
        }
        yarraypie = yarraypie.map{ $0 / Double(player.rank_list.count) * 100}
        
        setChartPie(xarraypie, values: yarraypie)
        setChartLine(xarrayline, values: yarraylinesum)
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
        
        playername.inputAccessoryView = doneToolbar
        playermoney.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        playername.resignFirstResponder()
        playermoney.resignFirstResponder()
    }

    
    func setChartLine(dataPoints: [String], values: [Double]) {
        var dataEntriesline: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntryline = ChartDataEntry(value: values[i], xIndex: i)
            dataEntriesline.append(dataEntryline)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntriesline, label: "\(players[playerNumber].name)")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    func setChartPie(dataPoints: [String], values: [Double]) {
        var dataEntriespie: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntrypie = ChartDataEntry(value: values[i], xIndex: i)
            dataEntriespie.append(dataEntrypie)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntriespie, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        for i in 0..<dataPoints.count {
            if i == 0{
                let color = UIColor.redColor()
                colors.append(color)
            }else if i == 1{
                let color = UIColor.orangeColor()
                colors.append(color)
            }else if i == 2{
                let color = UIColor.blueColor()
                colors.append(color)
            }else{
                let color = UIColor.lightGrayColor()
                colors.append(color)
            }
        }
        
        pieChartDataSet.colors = colors
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers
        if indexOfArray(viewControllers!, searchObject: self) == nil {
            // 戻るボタンが押された処理
            print("back!")
        }
        super.viewWillDisappear(animated)
    }
    
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in array.enumerate(){
            if value as! UIViewController == searchObject as! UIViewController {
                return index
            }
        }
        return nil
    }
    @IBAction func resultButton(sender: UIButton){
        let realm = try! Realm()
        //players = realm.objects(Player).map{$0}
        if playername.text != "" && playermoney.text != ""{
            print("changed name and money")
            try! realm.write{
                self.players[playerNumber].name = self.playername.text!
                self.players[playerNumber].money = Int(self.playermoney.text!)!
            }
            let alertController = UIAlertController(title: "Changed Name and Money!!", message: "Changed Name and Money to '\(self.players[playerNumber].name)' '\(self.players[playerNumber].money)'", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if playername.text != "" && playermoney.text == ""{
            print("changed name")
            try! realm.write{
                self.players[playerNumber].name = self.playername.text!
            }
            let alertController = UIAlertController(title: "Changed Name!!", message: "Changed Name to '\(self.players[playerNumber].name)'", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if playername.text == "" && playermoney.text != ""{
            print("changed money")
            try! realm.write{
                self.players[playerNumber].money = Int(self.playermoney.text!)!
            }
            let alertController = UIAlertController(title: "Changed Money!!", message: "Changed Money to '¥\(self.players[playerNumber].money)'", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
//            let alertController = UIAlertController(title: "Nothing Changed!!", message: "Nothing Changed", preferredStyle: .Alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alertController.addAction(defaultAction)
//            presentViewController(alertController, animated: true, completion: nil)
        }
        players = realm.objects(Player).map{$0}
    }
    
}