//
//  SMSwordNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMSwordNode: SKSpriteNode {
    //剣の種類
    var type: SwordType
    
    init(texture: SKTexture, type: SwordType){
        self.type = type
        var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //剣の作成
    func makeSword(location: CGPoint, node:SKNode, shotSound:SKAction){
        self.position = location
        
        //物理シミュレーション設定
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = true
        
        self.physicsBody?.categoryBitMask = ColliderType.Sword
        self.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Sword
        self.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Sword
        
        node.addChild(self)
        self.physicsBody?.velocity = CGVector.zeroVector
        self.physicsBody?.applyImpulse(CGVector(dx:-0.1, dy:50.0))
        
        //2秒後に消す
        var removeAction = SKAction.removeFromParent()
        var durationAction = SKAction.waitForDuration(1.50)
        var sequenceAction = SKAction.sequence([shotSound,durationAction,removeAction])
        self.runAction(sequenceAction)
        
        var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
        self.runAction(fadeAction)
        
        //パーティクル作成
        var point = CGPoint(x:0, y:-30)
        SMNodeUtil.makeMagicParticle(location, node: node)
        SMNodeUtil.makeSparkParticle(point, node: self)
    }
}
