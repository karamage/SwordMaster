//
//  SMEnemyBoss3.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/08/03.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyBoss3: SMEnemyNode {
    
    init(texture: SKTexture) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        x = frameWidth/2
        y = CGFloat(frameHeight)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.BOSS3, location: location, parentnode: enemysNode)
        self.isBoss = true
        self.hitpoint = 60
        if debugflg {
            self.hitpoint = 1
        }
        self.diffence = 0
        self.score = 3000
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
        makeEnegy(60)
        let move = SKAction.moveToY(frameHeight - 100, duration: 3.0)
        self.runAction(move)
    }
}