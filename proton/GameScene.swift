//
//  GameScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //当たり判定用
    struct ColliderType {
        static let Player: UInt32 = (1<<0)
        static let Enemy: UInt32 = (1<<1)
        static let Sword: UInt32 = (1<<2)
        static let Item: UInt32 = (1<<3)
        static let Wall: UInt32 = (1<<4)
        static let Enegy: UInt32 = (1<<5)
        static let None: UInt32 = (1<<9)
    }
    //ゲームオーバーフラグ
    var gameoverflg = false
    //敵を倒した数
    var killcount = 0
    
    //BGM
    let bgSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)
    
    //効果音
    var shotSound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
    var hitSound = SKAction.playSoundFileNamed("fade.mp3", waitForCompletion: false)
    var swordSound = SKAction.playSoundFileNamed("sword.mp3", waitForCompletion: false)
    
    //背景
    var bg = SKSpriteNode(imageNamed: "background2")
    //プレイヤー
    var player: SKSpriteNode!
    var playerTexture = SKTexture(imageNamed: "player1")
    
    //敵配置用ノード
    var enemysNode = SKNode()
    //敵１のテクスチャ
    var enemy1Texture = SKTexture(imageNamed: "enemy1")
    
    
    //剣配置用ノード
    var swordsNode = SKNode()
    //剣のテクスチャ
    var swordTexture = SKTexture(imageNamed: "swordex")
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //背景表示
        bg.position = CGPoint(x:0, y:0)
        bg.anchorPoint = CGPoint(x:0.5, y:0) //中央に合わせる
        bg.zPosition = -100
        self.addChild(bg)
        //self.size = CGSize(width: 320, height: 568)
        //bg.size = self.size
        makeBgParticle()
        
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-0.10)
        self.physicsWorld.contactDelegate = self
        
        //剣配置用ノード
        self.addChild(swordsNode)
        swordsNode.zPosition = 2
        
        //敵配置用ノード
        self.addChild(enemysNode)
        enemysNode.zPosition = 2
        
        //プレイヤーを作成
        makePlayer()
        
        //敵を作成する
        makeEnemySample()
        
        //BGMを鳴らす
        let bgSoundRepeat = SKAction.repeatActionForever(bgSound)
        //self.runAction(bgSoundRepeat)
        
    }
    
    //敵のサンプルを作る
    func makeEnemySample() {
        enemysNode.removeAllChildren()
        for i in 0..<10 {
            makeEnemy1()
        }
    }
    
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            //剣を作成する
            makeSword(location)
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //プレイヤー作成
    func makePlayer() {
        player = SKSpriteNode(texture: playerTexture)
        player.position = CGPoint(x: self.frame.size.width * 0.5, y: 50)
        
        //物理シミュレーション設定
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody?.dynamic = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Enegy
        player.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Enegy
        
        self.addChild(player)
        player.zPosition = 2
    }
    
    //敵1の作成
    func makeEnemy1() {
        let enemy1 = SKSpriteNode(texture: enemy1Texture)
        
        //物理シミュレーションを設定
        enemy1.physicsBody = SKPhysicsBody(texture: enemy1Texture, size: enemy1Texture.size())
        enemy1.physicsBody?.dynamic = true
        enemy1.physicsBody?.allowsRotation = true
        enemy1.physicsBody?.restitution = 0.5
        enemy1.physicsBody?.categoryBitMask = ColliderType.Enemy
        enemy1.physicsBody?.collisionBitMask = ColliderType.Player | ColliderType.Sword
        enemy1.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Sword
        
        //位置をランダムに作成する
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        var randX = arc4random_uniform(320)
        var randY = arc4random_uniform(100)
        x = CGFloat(randX)
        y = CGFloat(self.frame.size.height - CGFloat(randY))
        println("x:\(x) y:\(y)")
        
        enemysNode.addChild(enemy1)
        enemy1.position = CGPoint(x:x,y:y)
        
        //プレイヤーに迫って移動してくるようにする
        var action = SKAction.moveTo(player.position, duration: 10)
        enemy1.runAction(action)
    }
    
    //剣の作成
    func makeSword(location: CGPoint){
        var sword = SKSpriteNode(texture:swordTexture)
        sword.position = location
        
        //物理シミュレーション設定
        sword.physicsBody = SKPhysicsBody(texture: swordTexture, size: swordTexture.size())
        sword.physicsBody?.dynamic = true
        sword.physicsBody?.allowsRotation = true
        
        sword.physicsBody?.categoryBitMask = ColliderType.Sword
        sword.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Sword
        sword.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Sword
        
        swordsNode.addChild(sword)
        sword.physicsBody?.velocity = CGVector.zeroVector
        //sword.physicsBody?.velocity = CGVector(dx:1, dy:-2000)
        sword.physicsBody?.applyImpulse(CGVector(dx:-0.1, dy:50.0))
        
        //2秒後に消す
        var removeAction = SKAction.removeFromParent()
        var durationAction = SKAction.waitForDuration(1.50)
        var sequenceAction = SKAction.sequence([shotSound,durationAction,removeAction])
        sword.runAction(sequenceAction)
        
        var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
        sword.runAction(fadeAction)
        
        //パーティクル作成
        makeMagicParticle(location)
    }
    
    //衝突判定
    func didBeginContact(contact: SKPhysicsContact) {
        //すでにゲームオーバーだったら即リターン
        if gameoverflg {
            return
        }
        let swordType = ColliderType.Sword
        let enemyType = ColliderType.Enemy
        if (contact.bodyA.categoryBitMask & swordType == swordType ||
            contact.bodyB.categoryBitMask & swordType == swordType ) {
            //剣の衝突
            //敵に剣が当たったら消す
            if (contact.bodyA.categoryBitMask & enemyType == enemyType) {
                contact.bodyB.categoryBitMask = ColliderType.None
                makeColliParticle(contact.bodyA.node?.position)
                contact.bodyA.node?.removeFromParent()
                contact.bodyA.node?.removeAllActions()
                killcount++
            } else if (contact.bodyB.categoryBitMask & enemyType == enemyType) {
                contact.bodyA.categoryBitMask = ColliderType.None
                makeColliParticle(contact.bodyB.node?.position)
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.node?.removeAllActions()
                killcount++
            } else if contact.bodyA.categoryBitMask & ColliderType.None == ColliderType.None ||
                contact.bodyB.categoryBitMask & ColliderType.None == ColliderType.None {
                //剣と剣の衝突
                //contact.bodyA.categoryBitMask = ColliderType.None
                //contact.bodyB.categoryBitMask = ColliderType.None
                self.runAction(swordSound)
            }
        }
    }
    
    //背景用パーティクル作成
    func makeBgParticle() {
        let particle = SKEmitterNode(fileNamed: "scrollParticle.sks")
        bg.addChild(particle)
        
        particle.position = CGPoint(x: CGFloat(self.frame.size.width / 2), y: CGFloat(self.frame.height))
    }
    //魔法のパーティクルを作る
    func makeMagicParticle(position:CGPoint?) {
        makeParticle(position, filename:"magicParticle.sks")
    }
    //衝突のパーティクルを作る
    func makeColliParticle(position:CGPoint?) {
        makeParticle(position, filename:"MyParticle.sks")
        self.runAction(hitSound) //効果音を鳴らす
    }
    
    //パーティクル発生
    func makeParticle(position:CGPoint?, filename: String) {
        let particle = SKEmitterNode(fileNamed: filename)
        self.addChild(particle)
        
        //１秒後に消す
        var removeAction = SKAction.removeFromParent()
        var durationAction = SKAction.waitForDuration(1.50)
        var sequenceAction = SKAction.sequence([durationAction,removeAction])
        particle.runAction(sequenceAction)
        
        if let tmp = position {
            particle.position = tmp
        }
        particle.alpha = 1
        
        var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
        particle.runAction(fadeAction)
    }
}
