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
    //敵のテクスチャ
    var enemy1Texture = SKTexture(imageNamed: "enemy1")
    var enemy2Texture = SKTexture(imageNamed: "enemy2")
    var enemy4Texture = SKTexture(imageNamed: "enemy4")
    var boss1Texture = SKTexture(imageNamed: "boss1")
    var boss2Texture = SKTexture(imageNamed: "boss2")
    var boss3Texture = SKTexture(imageNamed: "boss3")
    
    func create(type:EnemyType) -> SMEnemyNode? {
        var enemy:SMEnemyNode? = nil
        switch type {
        case .CUBE:
            enemy = SMEnemyCube(texture: enemy1Texture) as SMEnemyNode?
        case .FLY:
            enemy = SMEnemyFly(texture: enemy2Texture) as SMEnemyNode?
        case .KNIGHT:
            enemy = SMEnemyKnight(texture: enemy4Texture) as SMEnemyNode?
        case .BOSS1:
            enemy = SMEnemyBoss1(texture: boss1Texture) as SMEnemyNode?
        case .BOSS2:
            enemy = SMEnemyBoss2(texture: boss2Texture) as SMEnemyNode?
        case .BOSS3:
            enemy = SMEnemyBoss3(texture: boss3Texture) as SMEnemyNode?
        default:
            break
        }
        return enemy
    }
}