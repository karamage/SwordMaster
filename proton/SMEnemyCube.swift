//
//  SMEnemyCube.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/12.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyCube: SMEnemyNode {
    init(texture: SKTexture) {
        //位置をランダムに作成する
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        let randX = arc4random_uniform(320)
        let randY = arc4random_uniform(100)
        x = CGFloat(randX)
        y = CGFloat(frameHeight - CGFloat(randY) + 100)
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.CUBE, location: location, parentnode: enemysNode)
        self.hitpoint = 1
        self.diffence = 0
        self.score = 10
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        
        let randY = arc4random_uniform(100)
        
        //プレイヤーに迫って移動してくるようにする
        var vector = SMNodeUtil.makePlayerVector(self.position, player: player)
        self.physicsBody?.density = 0.1
        self.physicsBody?.restitution = 0.3
        //self.physicsBody?.velocity = CGVector.zero
        //self.physicsBody?.applyImpulse(CGVector(dx:vector.dx + CGFloat(randY) / 10000, dy:vector.dy / 50000))
        
        hit.alpha = 0.7
        
        //回転のアニメーションをランダム時間で付ける
        let rotateAction = SKAction.rotateByAngle(CGFloat(360*M_PI/180), duration: 0.5)
        let rotateWaitAction = SKAction.waitForDuration(NSTimeInterval(CGFloat(randY) * 0.05))
        let rotate = SKAction.repeatActionForever(SKAction.sequence([rotateAction,rotateWaitAction]))
        self.runAction(rotate)
        
        //ずっとプレイヤーの方向を向くようにする
        // 姿勢へのConstraintsを作成.
        //let cons = SKConstraint.orientToPoint(player.position,offset: SKRange(constantValue: degreeToRadian(-90)))
        //enemy1.constraints = [cons]
    }
}
