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
        
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-2.00)
        self.physicsWorld.contactDelegate = self
        
        //剣配置用ノード
        self.addChild(swordsNode)
        swordsNode.zPosition = 2
        
        //敵配置用ノード
        self.addChild(enemysNode)
        enemysNode.zPosition = 2
        
        //プレイヤーを作成
        makePlayer()
    }
    
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
    func makeEnemy() {
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
        sword.physicsBody?.applyImpulse(CGVector(dx:0, dy:50.0))
    }
}
