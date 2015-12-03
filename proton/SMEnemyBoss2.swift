//
//  SMEnemyBoss2.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/08/03.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyBoss2: SMEnemyNode {
    var `guard`: SMGuardNode!
    init(texture: SKTexture) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        x = frameWidth/2
        y = CGFloat(frameHeight)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.BOSS2, location: location, parentnode: enemysNode)
        self.isBoss = true
        self.hitpoint = 80
        if debugflg {
            self.hitpoint = 1
        }
        self.diffence = 1
        self.score = 2000
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        //self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.1
        self.physicsBody?.density = 1000.0
        makeEnegy(50)
        makeEnegy2(3.0)
        let move = SKAction.moveToY(frameHeight - 100, duration: 3.0)
        self.runAction(move)
        //バリアを作成
        var guardpos = CGPoint(x:-10, y:-80)
        `guard` = SMGuardNode(texture: guardTexture, location: guardpos, parentnode: self)
        `guard`.makeGuard()
        `guard`.hitpoint = 40
    }
}