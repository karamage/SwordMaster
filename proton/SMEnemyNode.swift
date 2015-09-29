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
    
    //ボスかどうか
    var isBoss: Bool = false
    
    //初期化
    init(texture: SKTexture, type: EnemyType, location: CGPoint, parentnode:SKNode){
        self.type = type
        self.parentnode = parentnode
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
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
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
            self.shadowCastBitMask = 1
            //self.shadowedBitMask = 1
            //self.lightingBitMask = 1
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: self.texture!.size())
        }
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
        hit.alpha = 0.5
        hit.zPosition = 3
        self.addChild(hit!)
    }
    func makeEnegy(num: Int) {
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            //弾発射
            let point = CGPoint(x: self.position.x , y: self.position.y)
            for i in 0..<num {
                let enegy = enegyFactory.create(point)
                enegy.makeEnegy()
                enegy.shotEnegyRandom()
            }
        })
        let waitAction = SKAction.waitForDuration(2.0)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
    func makeEnegy2(interval: Double = 5.0) {
        //println("makeEnegy2()")
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            //println("makeEnegy2() customAction")
            var point = CGPoint(x: self.position.x , y: self.position.y)
            var enegy = enegyFactory.create(point)
            enegy.makeEnegy(10.0, den: 100.0)
            //enegy.shotEnegyRandom()
            enegy.shotEnegyPlayer()
            var scale = SKAction.scaleBy(3.0, duration: 1.0)
            enegy.runAction(scale)
            SMNodeUtil.makeParticleNode(CGPoint(x:0,y:0), filename: "enegyParticle.sks", hide: false, node: enegy)
        })
        let waitAction = SKAction.waitForDuration(interval)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
    //剣が当たった時の処理
    func hitSword(sword: SMSwordNode) {
        let damage = sword.attack - diffence
        if damage <= 0 {
            hit.removeAllActions()
            //ダメージを与えられない
            let fadeIn = SKAction.fadeInWithDuration(0)
            let fadeOut = SKAction.fadeOutWithDuration(0.5)
            let guardAnimAction = SKAction.animateWithTextures(guardAim, timePerFrame: 0.1, resize:false, restore:true)
            hit.runAction(SKAction.sequence([fadeIn,guardAnimAction,fadeOut]))
            bgNode.runAction(kakinSound)
            return
        }
        hitpoint -= (damage)
        
        //コンボの処理
        let waitAction = SKAction.waitForDuration(1.0)
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            combo = 0
            comboLabel.alpha = 0.0
        })
        comboLabel.removeAllActions()
        comboLabel.runAction(SKAction.sequence([waitAction, custumAction]))
        combo++
        if combo > 1 {
            comboLabel.text = "\(combo) Combo!"
            bgNode.runAction(comboSound)
            //comboLabel.alpha = 1.0
            if comboLabel.alpha == 0.0 {
                let fadeInAction = SKAction.fadeInWithDuration(0.5)
                let fadeInAction2 = SKAction.fadeAlphaTo(0.3, duration: 0.5)
                let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
                
                comboLabel.runAction(fadeInAction)
                //let x = comboLabel.position.x
                let move1 = SKAction.moveToX(self.scene!.frame.width + 10.0, duration: 0.0)
                let move2 = SKAction.moveToX(self.scene!.frame.width - 100.0, duration: 0.5)
                comboLabel.runAction(SKAction.sequence([move1,move2]))
                bgNode.runAction(koredeSound)
                //killAimNode.runAction(kiruSound)
                //killAimNode.runAction(kiruSound)
                //killAimNode.runAction(kiruSound)
                let killAnimAction = SKAction.animateWithTextures(killAim, timePerFrame: 0.1, resize:false, restore:true)
                killAimNode.runAction(killAnimAction)
                killAimNode.runAction(SKAction.sequence([fadeInAction2,fadeOutAction]) )
                let scale1 = SKAction.scaleTo(1.0, duration: 0.0)
                let scale2 = SKAction.scaleTo(3.0, duration: 1.0)
                killAimNode.runAction(SKAction.sequence([scale1,scale2]))
                //光の演出を付ける
                if #available(iOS 8.0, *) {
                    let light:SKLightNode = SKLightNode()
                    light.categoryBitMask = 1
                    light.falloff = 1
                    light.ambientColor = UIColor.whiteColor()
                    light.lightColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 0.9)
                    light.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
                    sword.addChild(light)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                comboLabel.alpha = 1.0
                let move2 = SKAction.moveToX(self.scene!.frame.width - 100.0, duration: 0.0)
                comboLabel.runAction(SKAction.sequence([move2]))
            }
        }
        
        sword.physicsBody?.categoryBitMask = ColliderType.None
        if hitpoint <= 0 {
            //敵が死んだ時の処理
            dead()
        } else {
            bgNode.runAction(explodeSound2)
            SMNodeUtil.makeParticleNode(self.position, filename:"hitParticle.sks", node:bgNode)
            let hitAnimAction = SKAction.animateWithTextures(hitAim, timePerFrame: 0.03, resize:false, restore:true)
            hit.removeAllActions()
            hit.runAction(hitAnimAction)
            hit.alpha = 0.8
            let fadeout = SKAction.fadeOutWithDuration(1.0)
            hit.runAction(fadeout)
        }
    }
    //敵が死んだ時の処理
    func dead() {
        SMNodeUtil.makeParticleNode(self.position, filename:"deadParticle.sks", node:bgNode)
        self.physicsBody?.categoryBitMask = ColliderType.None
        self.removeAllActions()
        
        //ボスの場合は大量のアイテム
        var itemnum = 1
        if isBoss {
            //println("boss dead")
            itemnum = 10
        }
        
        var itempos = self.position
        for i in 1...itemnum {
            let rand:CGFloat = CGFloat(arc4random_uniform(100))
            let randY:CGFloat = CGFloat(arc4random_uniform(100))
            var randp: CGFloat = 1.0
            var randyp: CGFloat = 1.0
            var x = self.position.x
            var y = self.position.y
            if i > 1 {
                if rand % 2 == 0 {
                    randp = -1
                }
                if randY % 2 == 0 {
                    randyp = -1
                }
                x = x + (rand * randp)
                y = y + (randY * randyp)
                itempos = CGPoint(x:x, y:y)
            }
            let item = itemFactory.createRandom(itempos)
            item?.makeItem()
        }
        
        var combop = 1.0
        if combo > 1 {
            combop = 1.0 * Double(combo)
        }
        totalScore = totalScore + Int(Double(self.score) * combop)
        scoreLabel.text = "\(totalScore)"
        if let delegate = self.delegate {
            delegate.enemyDeadDelegate(self)
        }
        SMNodeUtil.fadeRemoveNode(self)
        bgNode.runAction(explodeSound)
    }
    //デイニシャライザ
    deinit {
        //println("enemy deinit")
    }
}
