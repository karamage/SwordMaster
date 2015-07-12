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
        
        var randX = arc4random_uniform(320)
        var randY = arc4random_uniform(100)
        x = CGFloat(randX)
        y = CGFloat(728 - CGFloat(randY))
        let location = CGPoint(x:x, y:y)
        super.init(texture: texture, type: EnemyType.CUBE, location: location, parentnode: enemysNode)
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        
        //プレイヤーに迫って移動してくるようにする
        var action = SKAction.moveTo(player.position, duration: 20)
        self.runAction(action)
        
        var randY = arc4random_uniform(100)
        
        //回転のアニメーションをランダム時間で付ける
        var rotateAction = SKAction.rotateByAngle(CGFloat(360*M_PI/180), duration: 0.5)
        var rotateWaitAction = SKAction.waitForDuration(NSTimeInterval(CGFloat(randY) * 0.05))
        var rotate = SKAction.repeatActionForever(SKAction.sequence([rotateAction,rotateWaitAction]))
        self.runAction(rotate)
        
        //ずっとプレイヤーの方向を向くようにする
        // 姿勢へのConstraintsを作成.
        //let cons = SKConstraint.orientToPoint(player.position,offset: SKRange(constantValue: degreeToRadian(-90)))
        //enemy1.constraints = [cons]
    }
}
