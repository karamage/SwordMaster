//
//  SMEnemyFactory.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//敵のファクトリークラス
class SMEnemyFactory {
    //敵１のテクスチャ
    var enemy1Texture = SKTexture(imageNamed: "enemy1")
    var enemy2Texture = SKTexture(imageNamed: "enemy2")
    var boss1Texture = SKTexture(imageNamed: "boss1")
    
    func create(type:EnemyType) -> SMEnemyNode? {
        var enemy:SMEnemyNode? = nil
        switch type {
        case .CUBE:
            enemy = SMEnemyCube(texture: enemy1Texture) as SMEnemyNode?
        case .FLY:
            enemy = SMEnemyFly(texture: enemy2Texture) as SMEnemyNode?
        case .BOSS1:
            enemy = SMEnemyBoss1(texture: boss1Texture) as SMEnemyNode?
        default:
            break
        }
        return enemy
    }
}