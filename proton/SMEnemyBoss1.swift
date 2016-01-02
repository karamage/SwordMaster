//
//  SMEnemyBoss1.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/15.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyBoss1: SMEnemyNode {
    var `guard`: SMGuardNode!
    init(texture: SKTexture) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        x = frameWidth/2
        y = CGFloat(frameHeight)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.BOSS1, location: location, parentnode: enemysNode)
        //self.isBoss = true
        self.hitpoint = 40
        if debugflg {
            self.hitpoint = 1
        }
        self.diffence = 0
        self.score = 2000
        
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        
        if #available(iOS 8.0, *) {
            self.shadowCastBitMask = 1
        } else {
            // Fallback on earlier versions
        }
        //self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.1
        self.physicsBody?.density = 1000.0
        makeEnegy(15)
        makeEnegy2()
        let move = SKAction.moveToY(frameHeight - 100, duration: 3.0)
        self.runAction(move)
        
        //println("boss1 guard make")
        
        //バリアを作成
        let guardpos = CGPoint(x:-10, y:-80)
        `guard` = SMGuardNode(texture: guardTexture, location: guardpos, parentnode: self)
        `guard`.makeGuard()
    }
}