//
//  SMEnegyNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/16.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit


class SMEnegyNode: SKSpriteNode {
    var startPoint: CGPoint!
    weak var parentnode: SKNode!
    init(texture: SKTexture, location: CGPoint,parentnode:SKNode){
        self.startPoint = location
        self.parentnode = parentnode
        texture.filteringMode = .Nearest
        var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y)
        //self.blendMode = SKBlendMode.Add
        self.alpha = 0.9
        self.zPosition = 20
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeEnegy() {
        //物理シミュレーション設定
        //self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: 3.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.density = 10.0
        
        self.physicsBody?.categoryBitMask = ColliderType.Enegy
        self.physicsBody?.collisionBitMask = ColliderType.Sword
        self.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Enegy
        
        parentnode.addChild(self)
    }
    func contactSword(sword:SMSwordNode) {
        SMNodeUtil.makeParticleNode(CGPoint(x: self.position.x, y: self.position.y), filename: "MyParticle.sks", node: parentnode)
        if sword.isShot == false {
            SMNodeUtil.fadeRemoveNode(self)
        }
    }
    func shotEnegy(dx: CGFloat, dy: CGFloat) {
        self.physicsBody?.velocity = CGVector.zeroVector
        self.physicsBody?.applyImpulse(CGVector(dx:dx, dy:dy))
        //self.physicsBody?.applyForce(CGVector(dx:0, dy: -50.0))
        SMNodeUtil.fadeRemoveNode10(self)
    }
    func shotEnegyRandom() {
        var randX = arc4random_uniform(100)
        var randY = arc4random_uniform(100)
        var rand = arc4random_uniform(100)
        var minus = 1
        if rand % 2 == 0 {
            minus = -1
        }
        var dx: CGFloat = CGFloat(randX/40) * CGFloat(minus)
        var dy: CGFloat = CGFloat(randY/40) * CGFloat(-1)
        shotEnegy(dx, dy: dy)
    }
}