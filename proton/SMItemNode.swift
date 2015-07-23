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
        var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y - 40)
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeItem() {
        //物理シミュレーションを設定
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.density = 10.0
        self.physicsBody?.categoryBitMask = ColliderType.Item
        self.physicsBody?.collisionBitMask = ColliderType.Sword
        self.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Sword
        
        if let parentnode = self.parentnode {
            parentnode.addChild(self)
        }
    }
}