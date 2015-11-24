//
//  detail.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/11/20.
//  Copyright © 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailDescriptionLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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