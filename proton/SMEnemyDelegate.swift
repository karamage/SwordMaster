//
//  SMEnemyDelegate.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/14.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

protocol SMEnemyDelegate {
    //敵が死んだときに呼び出される
    func enemyDeadDelegate(enemy: SMEnemyNode)
}