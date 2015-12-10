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
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y)
        //self.blendMode = SKBlendMode.Add
        self.alpha = 0.9
        self.zPosition = 20
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeEnegy(rad:CGFloat = 3.0, den:CGFloat = 10.0) {
        //物理シミュレーション設定
        //self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: rad)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.density = den
        
        self.physicsBody?.categoryBitMask = ColliderType.Enegy
        self.physicsBody?.collisionBitMask = ColliderType.Sword | ColliderType.Guard2
        self.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Sword | ColliderType.Guard2
        
        parentnode.addChild(self)
    }
    func contactSword(sword:SMSwordNode) {
        //SMNodeUtil.makeParticleNode(CGPoint(x: self.position.x, y: self.position.y), filename: "MyParticle.sks", node: parentnode)
        if sword.isShot == false {
            SMNodeUtil.fadeRemoveNode(self)
        }
    }
    func shotEnegy(dx: CGFloat, dy: CGFloat) {
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx:dx, dy:dy))
        //self.physicsBody?.applyForce(CGVector(dx:0, dy: -50.0))
        SMNodeUtil.fadeRemoveNode10(self)
    }
    func shotEnegyRandom() {
        let randX = arc4random_uniform(100)
        let randY = arc4random_uniform(100)
        let rand = arc4random_uniform(100)
        var minus = 1
        if rand % 2 == 0 {
            minus = -1
        }
        let dx: CGFloat = CGFloat(CGFloat(randX) * 0.05) * CGFloat(minus)
        let dy: CGFloat = CGFloat(CGFloat(randY) * 0.025) * CGFloat(-1)
        shotEnegy(dx, dy: dy)
    }
    func shotEnegyPlayer() {
        //プレイヤーに迫って移動してくるようにする
        let vector = SMNodeUtil.makePlayerVector(self.position, player: player)
        //self.physicsBody?.velocity = CGVector.zeroVector
        //self.physicsBody?.applyImpulse(CGVector(dx:vector.dx / 100, dy:vector.dy / 500))
        shotEnegy(vector.dx, dy: vector.dy)
    }
}