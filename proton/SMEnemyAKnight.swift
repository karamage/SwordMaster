//
//  SMEnemyAKnight.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/08/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyAKnight: SMEnemyNode {
    var `guard`: SMGuardNode!
    var x:CGFloat = 0
    var y:CGFloat = 0
    
    init(texture: SKTexture) {
        //位置をランダムに作成する
        var randY = arc4random_uniform(10)
        let randX = arc4random_uniform(200)
        x = frameWidth/2 + 100.0 - CGFloat(randX)
        y = CGFloat(frameHeight - 120)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.AKNIGHT, location: location, parentnode: enemysNode)
        self.hitpoint = 40
        if debugflg {
            self.hitpoint = 1
        }
        self.diffence = 4
        self.score = 100
        self.itemnum = 5
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1.9
        self.physicsBody?.density = 2000.0
        
        //バリアを作成
        let guardpos = CGPoint(x:-10, y:-80)
        `guard` = SMGuardNode(texture: guardTexture, location: guardpos, parentnode: self)
        `guard`.hitpoint = 20
        
        `guard`.makeGuard()
        
        attackPlayer(5.0)
    }
}