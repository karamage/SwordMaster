//
//  SMPlayer.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//自機ノード管理クラス
class SMPlayerNode: SKSpriteNode {
    //装備している剣の種類
    var swordType: SwordType = SwordType.EXCALIBUR
    
    func test() {
        
    }
    
    //プレイヤー作成
    func makePlayer(node: SKNode, textures: [SKTexture]) {
        self.position = CGPoint(x: node.frame.size.width * 0.5, y: 0)
        
        //物理シミュレーション設定
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.Player
        self.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Enegy
        self.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Enegy
        
        node.addChild(self)
        self.zPosition = 2
        
        //パラパラアニメーション
        let paraAction = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
        let repeatParaAction = SKAction.repeatActionForever(paraAction)
        self.runAction(repeatParaAction)
        
        //画面下から登場
        var playerAction = SKAction.moveToY(50, duration: 2)
        self.runAction(playerAction)
        
        //パーティクル作成
        //let particlePosition = CGPoint(x: self.frame.size.width * 0.5, y: 50)
        let particlePosition = CGPoint(x: 0, y: 25)
        SMNodeUtil.makeParticleNode(particlePosition, filename:"playerParticle.sks", hide:false, node:self)
    }
}