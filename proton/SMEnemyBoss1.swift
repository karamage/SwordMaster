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
    
    init(texture: SKTexture) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        x = frameWidth/2
        y = CGFloat(frameHeight - 100)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.FLY, location: location, parentnode: enemysNode)
        self.hitpoint = 10
        self.diffence = 0
        self.score = 1000
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
        makeEnegy(10)
    }
}