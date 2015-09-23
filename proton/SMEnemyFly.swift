//
//  SMEnemyFly.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/14.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyFly: SMEnemyNode {
    
    init(texture: SKTexture) {
        //位置をランダムに作成する
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        let randX = arc4random_uniform(100)
        let randY = arc4random_uniform(100)
        x = frameWidth/2 - 50 + CGFloat(randX)
        y = CGFloat(frameHeight - CGFloat(randY) + 50)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.FLY, location: location, parentnode: enemysNode)
        self.hitpoint = 2
        self.diffence = 0
        self.score = 20
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.dynamic = true
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.density = 5.0
        
        let rand1 = Double(arc4random_uniform(100)) * 0.01
        let rand2 = Double(arc4random_uniform(100)) * 0.01
        
        //ゆらゆら移動してくるようにする
        let wait1 = SKAction.waitForDuration(rand1)
        let action1 = SKAction.moveBy(CGVector(dx: 100, dy: 0), duration: 0.5)
        let wait2 = SKAction.waitForDuration(rand2)
        let action2 = SKAction.moveBy(CGVector(dx: -100, dy: 0), duration: 0.5)
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait1,action1,wait2,action2,wait2,action2,wait1,action1])))
        
        makeEnegy(3)
    }
}
