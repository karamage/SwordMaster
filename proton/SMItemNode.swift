//
//  SMItemNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/17.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMItemNode: SKSpriteNode {
    var type: ItemType = ItemType.COIN
    weak var parentnode: SKNode!
    init(texture: SKTexture, type: ItemType, location: CGPoint, parentnode:SKNode){
        self.type = type
        self.parentnode = parentnode
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y - 40)
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeItem() {
        //物理シミュレーションを設定
        /*
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: self.texture!.size())
        }*/
        self.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.density = 100.0
        self.physicsBody?.categoryBitMask = ColliderType.Item
        self.physicsBody?.collisionBitMask = ColliderType.Item
        self.physicsBody?.contactTestBitMask = ColliderType.Player
        
        //色をつける
        switch type {
        case .SWORDPOWERUP:
            self.color = UIColor.redColor()
            self.colorBlendFactor = 0.9
            break
        case .SWORDCHARGEUP:
            self.color = UIColor.blueColor()
            self.colorBlendFactor = 0.9
            break
        default:
            break
        }
        
        if let parentnode = self.parentnode {
            parentnode.addChild(self)
        }
        //フェードインする
        self.alpha = 0.0
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        self.runAction(fadeIn)
    }
    //剣と衝突したときの処理
    func contactSword(sword: SMSwordNode) {
        let vector = SMNodeUtil.makePlayerVector(self.position, player: player)
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx: vector.dx/20, dy:vector.dy/20))
        //SMNodeUtil.makeParticleNode(self.position, filename: "MyParticle.sks", node: parentnode)
    }
}