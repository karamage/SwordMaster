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
    var inithitpoint = 0
    var smokecount = 0
    
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
    
    //アイテムの数
    var itemnum = 1
    
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
        /*
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
            self.shadowCastBitMask = 1
        } else {
            // Fallback on earlier versions
            self.physicsBody = SKPhysicsBody(rectangleOfSize: self.texture!.size())
        }*/
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.texture!.size().width * 0.8, height:self.texture!.size().height/2 ))
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
        let tmpnum = num + (num * stageManager.clearNum) // クリアする度に難しくなる
        weak var tmpself = self
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            let rand:CGFloat = CGFloat(arc4random_uniform(100))
            let custumAction2 = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
                //弾発射
                let point = CGPoint(x: self.position.x , y: self.position.y)
                for i in 0..<tmpnum {
                    let enegy = enegyFactory.create(point)
                    enegy.makeEnegy()
                    enegy.shotEnegyRandom()
                }
            })
            let waitAction2 = SKAction.waitForDuration(0.03 * Double(rand))
            tmpself?.runAction(SKAction.sequence([waitAction2,custumAction2]))
        })
        let waitAction = SKAction.waitForDuration(1.5)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
    func makeEnegy2(interval: Double = 5.0) {
        //println("makeEnegy2()")
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            //println("makeEnegy2() customAction")
            let rand:CGFloat = CGFloat(arc4random_uniform(100))
            let custumAction2 = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
                var point = CGPoint(x: self.position.x , y: self.position.y)
                var enegy = enegyFactory.create(point)
                enegy.makeEnegy(10.0, den: 100.0)
                //enegy.shotEnegyRandom()
                enegy.shotEnegyPlayer()
                var scale = SKAction.scaleBy(3.0, duration: 1.0)
                enegy.runAction(scale)
                SMNodeUtil.makeParticleNode(CGPoint(x:0,y:0), filename: "enegyParticle.sks", hide: false, node: enegy)
                //光の演出を付ける
                if #available(iOS 8.0, *) {
                    let light:SKLightNode = SKLightNode()
                    light.categoryBitMask = 1
                    light.falloff = 1
                    light.ambientColor = UIColor.whiteColor()
                    light.lightColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 0.9)
                    light.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
                    enegy.addChild(light)
                } else {
                    // Fallback on earlier versions
                }
            })
            let waitAction2 = SKAction.waitForDuration(0.03 * Double(rand))
            bgNode.runAction(SKAction.sequence([waitAction2,custumAction2]))
        })
        let waitAction = SKAction.waitForDuration(interval)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
    //剣が当たった時の処理
    func hitSword(sword: SMSwordNode) {
        if inithitpoint == 0 {
            inithitpoint = hitpoint //初期HP
        }
        let damage = sword.attack - diffence - (stageManager.clearNum) //周回するごとに難しくなる
        sword.attack = Int(Double(damage) * 0.8)
        sword.hitpoint--
        
        //剣のパーティクル削除
        for child in sword.children {
            child.removeFromParent()
        }
        
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
            bgNode.runAction(comboSound)
            bgNode.runAction(comboSound)
            //comboLabel.alpha = 1.0
            if comboLabel.alpha == 0.0 {
                
                let fadeInAction = SKAction.fadeInWithDuration(0.5)
                let fadeInAction2 = SKAction.fadeAlphaTo(0.3, duration: 0.5)
                let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
                
                comboLabel.runAction(fadeInAction)
                //let x = comboLabel.position.x
                let scale1 = SKAction.scaleTo(1.0, duration: 0.0)
                let scale2 = SKAction.scaleTo(3.0, duration: 2.0)
                let move1 = SKAction.moveToX(self.scene!.frame.width + 10.0, duration: 0.0)
                let move2 = SKAction.moveToX(self.scene!.frame.width - 200.0, duration: 0.5)
                comboLabel.runAction(SKAction.sequence([scale1, move1,move2, scale2]))
                bgNode.runAction(koredeSound)
                
                enemysNode.speed = 0.1
                enemysNode.scene!.physicsWorld.gravity = CGVector(dx:0.0, dy:0.40)
                let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
                    enemysNode.speed = 1.0
                    enemysNode.scene!.physicsWorld.gravity = CGVector(dx:0.0, dy:-0.10)
                })
                let waitAction = SKAction.waitForDuration(0.7)
                bgNode.runAction(SKAction.sequence([waitAction,custumAction]))
                
                let killAnimAction = SKAction.animateWithTextures(killAim, timePerFrame: 0.1, resize:false, restore:true)
                killAimNode.runAction(killAnimAction)
                killAimNode.runAction(SKAction.sequence([fadeInAction2,fadeOutAction]) )
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
        
        if sword.hitpoint <= 0 || sword.attack <= 0 {
            sword.physicsBody?.categoryBitMask = ColliderType.None
        }
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
            
            var smokecountmax = 3
            if hitpoint <= (inithitpoint/2) {
                self.color = UIColor.redColor()
                self.colorBlendFactor = 0.2
                if hitpoint <= (inithitpoint/4) {
                    self.colorBlendFactor = 0.5
                    smokecountmax = 8
                }
                
                if smokecount++ <= smokecountmax {
                    let rand:CGFloat = CGFloat(arc4random_uniform(10))
                    let randY:CGFloat = CGFloat(arc4random_uniform(10))
                    SMNodeUtil.makeParticleNode(CGPoint(x: CGFloat(rand), y: CGFloat(randY)), filename: "smoke.sks", hide: false, node: self)
                }
            }
        }
    }
    //敵が死んだ時の処理
    func dead() {
        SMNodeUtil.makeParticleNode(self.position, filename:"deadParticle.sks", node:bgNode)
        SMNodeUtil.makeParticleNode(self.position, filename:"hitParticle.sks", node:bgNode)
        SMNodeUtil.makeParticleNode(self.position, filename:"shopButton.sks", node:bgNode)
        self.physicsBody?.categoryBitMask = ColliderType.None
        self.removeAllActions()
        
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
    
    //x座標をプレイヤーに追尾する
    func moveXToPlayer() {
        weak var tmpself = self
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            let moveX = SKAction.moveToX(player.position.x, duration: 2.0)
            tmpself!.runAction(SKAction.sequence([moveX]))
        })
        let waitAction = SKAction.waitForDuration(5.0)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction])))
    }
}
