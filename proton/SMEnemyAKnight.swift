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
        self.hitpoint = 5
        self.diffence = 1
        self.score = 100
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.9
        self.physicsBody?.density = 40.0
        
        //バリアを作成
        let guardpos = CGPoint(x:-10, y:-80)
        `guard` = SMGuardNode(texture: guardTexture, location: guardpos, parentnode: self)
        `guard`.hitpoint = 10
        
        `guard`.makeGuard()
        weak var tmpself = self
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            let move = SKAction.moveTo(player.position, duration: 3.0)
            let remove = SKAction.moveToY(frameHeight - 120, duration: 1.0)
            tmpself!.runAction(SKAction.sequence([move,remove]))
        })
        let waitAction = SKAction.waitForDuration(5.0)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
}