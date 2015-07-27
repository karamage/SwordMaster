//
//  SMEnemyNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/12.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnemyNode: SKSpriteNode {
    //敵タイプ
    var type: EnemyType!
    //耐久力
    var hitpoint: Int = 1
    //防御力
    var diffence: Int = 0
    //親ノード
    weak var parentnode: SKNode?
    //スコア
    var score: Int = 1
    
    //死んだ時の通知用
    weak var delegate: SMEnemyGroup?
    
    //ヒットエフェクト
    var hit: SKSpriteNode!
    
    //初期化
    init(texture: SKTexture, type: EnemyType, location: CGPoint, parentnode:SKNode){
        self.type = type
        self.parentnode = parentnode
        var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y)
        self.zPosition = 2
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //敵の作成
    func makeEnemy() {
        //物理シミュレーションを設定
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.categoryBitMask = ColliderType.Enemy
        self.physicsBody?.collisionBitMask = ColliderType.Player | ColliderType.Sword
        self.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Sword
        
        if let parentnode = self.parentnode {
            parentnode.addChild(self)
        }
        //フェードインする
        self.alpha = 0.0
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        self.runAction(fadeIn)
        //アニメーションを作成
        hit = SKSpriteNode(texture: hitAim[0], size: hitAim[0].size())
        hit.blendMode = SKBlendMode.Add
        hit.alpha = 0.7
        self.addChild(hit!)
    }
    func makeEnegy(num: Int) {
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
            //弾発射
            var point = CGPoint(x: self.position.x , y: self.position.y)
            for i in 0..<num {
                var enegy = enegyFactory.create(point)
                enegy.makeEnegy()
                enegy.shotEnegyRandom()
            }
        })
        let waitAction = SKAction.waitForDuration(2.0)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
    //剣が当たった時の処理
    func hitSword(sword: SMSwordNode) {
        sword.physicsBody?.categoryBitMask = ColliderType.None
        self.runAction(sasaruSound)
        hitpoint -= (sword.attack - diffence)
        if hitpoint <= 0 {
            //敵が死んだ時の処理
            dead()
        } else {
            SMNodeUtil.makeParticleNode(self.position, filename:"hitParticle.sks", node:bgNode)
            var hitAnimAction = SKAction.animateWithTextures(hitAim, timePerFrame: 0.02, resize:false, restore:true)
            hit.runAction(hitAnimAction)
        }
    }
    func dead() {
        SMNodeUtil.makeParticleNode(self.position, filename:"deadParticle.sks", node:bgNode)
        self.physicsBody?.categoryBitMask = ColliderType.None
        self.removeAllActions()
        
        //アイテムを出現させる
        var item = itemFactory.createRandom(self.position)
        item?.makeItem()
        
        totalScore = totalScore + self.score
        scoreLabel.text = "\(totalScore)"
        SMNodeUtil.fadeRemoveNode(self)
        if let delegate = self.delegate {
            delegate.enemyDeadDelegate(self)
        }
    }
    //デイニシャライザ
    deinit {
        println("enemy deinit")
    }
}
