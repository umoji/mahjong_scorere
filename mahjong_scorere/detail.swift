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
    @IBOutlet var detailDescriptionLabel: UILabel?
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("playerNumber is \(playerNumber)")
        let realm = try! Realm()
        players = realm.objects(Player).map { $0 }
        let player = players[playerNumber]
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        var xarray = [String]()
        var yarray = [Double]()
        
        for (var i=0;i<player.point_list.count;i++){
            xarray.append("\(i+1)")
        }
        
        for (var j=0;j<player.point_list.count;j++){
            yarray.append(Double(player.point_list[j].point))
        }
        
        setChart(xarray, values: yarray)
        
        // Do any additional setup after loading the view.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData

        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
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