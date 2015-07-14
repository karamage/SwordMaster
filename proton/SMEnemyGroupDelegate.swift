//
//  SMEnemyGroupDelegate.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/14.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//敵に関する移譲処理
protocol SMEnemyGroupDelegate {
    //次の敵グループを出現させる
    func nextEnemyGroupDelegate()
}