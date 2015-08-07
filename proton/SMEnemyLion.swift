//
//  SMEnemyLion.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/08/06.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyLion: SMEnemyNode {
    var guard: SMGuardNode!
    
    init(texture: SKTexture) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        var randX = arc4random_uniform(200)
        x = CGFloat(randX)
        x = frameWidth/2 + 100.0 - CGFloat(randX)
        y = CGFloat(frameHeight)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.LION, location: location, parentnode: enemysNode)
        self.hitpoint = 5
        self.diffence = 0
        self.score = 50
        
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
        //makeEnegy(3)
        makeEnegy2()
        let move = SKAction.moveToY(frameHeight - 100, duration: 3.0)
        self.runAction(move)
        
        //バリアを作成
        var guardpos = CGPoint(x:-10, y:-80)
        guard = SMGuardNode(texture: guardTexture, location: guardpos, parentnode: self)
        guard.makeGuard()
        guard.hitpoint = 3
    }
}