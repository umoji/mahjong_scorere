//
//  Player_Database.swift
//  mahjong_scorere
//
//  Created by Yoshizawa Tomoya on 2015/10/31.
//  Copyright © 2015年 Tomoya Yoshizawa. All rights reserved.
//

import UIKit
import RealmSwift
import PNChartSwift

// Pointsクラス
class Points: Object {
    dynamic var point: Int = 0
}

class Ranks: Object {
    dynamic var rank: Int = 0
}

//// Playerクラス
class Player: Object {

    // プロパティと初期値の設定
    dynamic var order: Int = 0
    dynamic var name: String = ""
    dynamic var money: Int = 0
    dynamic var identifier: String = ""
    var point_list = List<Points>()
    var rank_list = List<Ranks>()
    
//    override class func primaryKey() -> String {
//        return "number"
//    }
    
}