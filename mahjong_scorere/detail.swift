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

class DetailViewController: UIViewController {
    var players = [Player]()
//    @IBOutlet var detailDescriptionLabel: UILabel?
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        let player = players[playerNumber]
        lineChartView.descriptionText = ""
        pieChartView.descriptionText = ""
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var xarrayline = [String]()
        var yarrayline = [Double]()
        var yarraylinesum = [Double]()
        let xarraypie = ["1位","2位","3位","4位"]
        var yarraypie = [0.0,0.0,0.0,0.0]
        
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
        
        setChartLine(xarrayline, values: yarraylinesum)
        setChartPie(xarraypie, values: yarraypie)
    }
    
    func setChartLine(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData

        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "\(players[playerNumber].name)")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    func setChartPie(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "\(players[playerNumber].name)")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
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
    
}