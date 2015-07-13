//
//  SMEnemyGroup.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//敵の集団管理クラス
class SMEnemyGroup {
    var enemys: [SMEnemyNode]!
    
    init(enemys: [SMEnemyNode]) {
        self.enemys = enemys
    }
    
    //敵の集団を作成
    func makeEnemyGroup() {
        for enemy in enemys {
            enemy.makeEnemy()
        }
    }
}