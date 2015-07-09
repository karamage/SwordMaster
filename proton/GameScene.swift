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
    //ラベル
    let gameoverLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    let scoreLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    
    //スコア
    var score: UInt = 0

    //ゲームオーバーフラグ
    var gameoverflg = false
    //敵作成フラグ
    var makeenemyflg = false
    
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
    var playerTexture2 = SKTexture(imageNamed: "player2")
    
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
        
        //背景を徐々に下にスクロールする
        var bgScrollAction = SKAction.moveToY(-60.0, duration: 20)
        var bgScrollRevAction = SKAction.moveToY(15.0, duration: 10)
        var bgScroll = SKAction.repeatActionForever(SKAction.sequence([bgScrollAction,bgScrollRevAction]))
        bg.runAction(bgScroll)
        
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-0.10)
        self.physicsWorld.contactDelegate = self
        
        //ラベルの表示
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scoreLabel.zPosition = 1000
        self.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height - 30)
        
        //剣配置用ノード
        swordsNode.position = CGPoint(x:0, y:0)
        //swordsNode.anchorPoint = CGPoint(x:0, y:0) //中央に合わせる
        self.addChild(swordsNode)
        //swordsNode.size = self.size
        swordsNode.zPosition = 2
        
        //敵配置用ノード
        enemysNode.position = CGPoint(x:0, y:0)
        self.addChild(enemysNode)
        enemysNode.zPosition = 2
        
        //プレイヤーを作成
        makePlayer()
        
        //羽のアニメーションを切り出す
        var haneAim: [SKTexture] = explodeAnime("wing", xFrame: 5, yFrame: 6)
        var haneAim2: [SKTexture] = [SKTexture](haneAim[7...22])
        var hane = SKSpriteNode(texture: haneAim[0], size: haneAim[0].size())
        self.addChild(hane)
        hane.position = CGPoint(x: self.frame.size.width/2, y: 50)
        
        var haneAnimAction = SKAction.animateWithTextures(haneAim, timePerFrame: 0.1, resize:false, restore:true)
        var haneAnimAction2 = SKAction.animateWithTextures(haneAim2, timePerFrame: 0.1, resize:false, restore:true)
        var repeatHaneAction = SKAction.repeatActionForever(haneAnimAction2)
        hane.runAction(SKAction.sequence([haneAnimAction,repeatHaneAction]))
        
        //ワープのアニメーション
        var warpAim: [SKTexture] = explodeAnime("warp", xFrame: 2, yFrame: 13)
        var warpAim2: [SKTexture] = [SKTexture](warpAim[0...14])
        var warp = SKSpriteNode(texture: warpAim[0], size: warpAim[0].size())
        self.addChild(warp)
        warp.position = CGPoint(x: self.frame.size.width/2, y: 50)
        var warpAnimAction = SKAction.animateWithTextures(warpAim2, timePerFrame: 0.1, resize:false, restore:true)
        var warpRemoveAction = SKAction.removeFromParent()
        warp.runAction(SKAction.sequence([warpAnimAction,warpRemoveAction]))
        
        //敵を作成する
        makeEnemySample()
        
        //BGMを鳴らす
        let bgSoundRepeat = SKAction.repeatActionForever(bgSound)
        //self.runAction(bgSoundRepeat)
        
    }
    
    //敵のサンプルを作る
    func makeEnemySample() {
        //enemysNode.removeAllChildren()
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
        if makeenemyflg {
            makeenemyflg = false
            makeEnemySample()
        }
    }
    
    //プレイヤー作成
    func makePlayer() {
        player = SKSpriteNode(texture: playerTexture)
        player.position = CGPoint(x: self.frame.size.width * 0.5, y: 0)
        
        //物理シミュレーション設定
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody?.dynamic = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Enegy
        player.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Enegy
        
        self.addChild(player)
        player.zPosition = 2
        
        //パラパラアニメーション
        let paraAction = SKAction.animateWithTextures([playerTexture,playerTexture2], timePerFrame: 0.2)
        let repeatParaAction = SKAction.repeatActionForever(paraAction)
        player.runAction(repeatParaAction)
        
        //画面下から登場
        var playerAction = SKAction.moveToY(50, duration: 2)
        player.runAction(playerAction)
        
        //パーティクル作成
        let particlePosition = CGPoint(x: self.frame.size.width * 0.5, y: 50)
        makeParticle(particlePosition, filename:"playerParticle.sks", hide:false)
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
        //println("x:\(x) y:\(y)")
        
        enemysNode.addChild(enemy1)
        enemy1.position = CGPoint(x:x,y:y)
        
        //プレイヤーに迫って移動してくるようにする
        var action = SKAction.moveTo(player.position, duration: 10)
        enemy1.runAction(action)
        
        //回転のアニメーションをランダム時間で付ける
        var rotateAction = SKAction.rotateByAngle(CGFloat(360*M_PI/180), duration: 0.5)
        var rotateWaitAction = SKAction.waitForDuration(NSTimeInterval(CGFloat(randY) * 0.05))
        var rotate = SKAction.repeatActionForever(SKAction.sequence([rotateAction,rotateWaitAction]))
        enemy1.runAction(rotate)
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
                killEnemy(contact.bodyA.node)
            } else if (contact.bodyB.categoryBitMask & enemyType == enemyType) {
                contact.bodyA.categoryBitMask = ColliderType.None
                killEnemy(contact.bodyB.node)
            } else if contact.bodyA.categoryBitMask & ColliderType.None == ColliderType.None ||
                contact.bodyB.categoryBitMask & ColliderType.None == ColliderType.None {
                //剣と剣の衝突
                //contact.bodyA.categoryBitMask = ColliderType.None
                //contact.bodyB.categoryBitMask = ColliderType.None
                self.runAction(swordSound)
            }
        }
    }
    
    //敵を倒した時の処理
    func killEnemy(enemynode: SKNode!) {
        enemynode.physicsBody?.categoryBitMask = ColliderType.None
        makeColliParticle(enemynode.position)
        killcount++
        score += 10
        scoreLabel.text = "\(score)"
        if killcount % 10 == 0 {
            makeenemyflg = true
        }
        fadeRemoveNode(enemynode)
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
    func makeParticle(position:CGPoint?, filename: String, hide: Bool = true) {
        let particle = SKEmitterNode(fileNamed: filename)
        self.addChild(particle)
        
        if let tmp = position {
            particle.position = tmp
        }
        
        //消さないんだったらリターン
        if !hide {
            return
        }
        fadeRemoveNode(particle)
    }
    
    //一秒後にフェードしながらノードを消す
    func fadeRemoveNode(removenode: SKNode!) {
        //１秒後に消す
        var removeAction = SKAction.removeFromParent()
        var durationAction = SKAction.waitForDuration(1.50)
        var sequenceAction = SKAction.sequence([durationAction,removeAction])
        removenode.runAction(sequenceAction)
        
        removenode.alpha = 1
        
        var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
        removenode.runAction(fadeAction)
    }
    
    //一枚の画像からアニメーションを切り出す
    func explodeAnime(imageName: String, xFrame: UInt, yFrame: UInt) -> [SKTexture] {
        
        var ret: [SKTexture] = []
        var image = UIImage(named: imageName)
        
        var inner: CGImageRef! = image?.CGImage
        
        var xFrameInt: Int = Int(xFrame)
        var yFrameInt: Int = Int(yFrame)
        
        //var width: Int = Int(image?.size.width) / xFrameInt
        var width:Int = 0
        var height:Int = 0
        var scale: CGFloat = 0
        if let tmpimage = image {
            width = Int(tmpimage.size.width) / xFrameInt
            height = Int(tmpimage.size.height) / yFrameInt
            scale = tmpimage.scale
        }
        
        var fx: CGFloat = 0
        var fy: CGFloat = 0
        var fwidth: CGFloat = 0
        var fheight: CGFloat = 0
        for i in 0..<yFrameInt {
            for i2 in 0..<xFrameInt {
                fx = 0+(CGFloat(i2 * width) * scale)
                fy = 0+(CGFloat(i * height) * scale)
                fwidth = CGFloat(width)*scale
                fheight = CGFloat(height)*scale
                var rect: CGRect = CGRectMake(fx, fy, fwidth, fheight)
                var ref: CGImageRef = CGImageCreateWithImageInRect(inner, rect)
                //var rev: UIImage? = UIImage(CGImage: ref)
                var texture = SKTexture(CGImage: ref)
                ret.append(texture)
            }
        }
        
        return ret
    }
}
