//
//  GameScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit
import CoreMotion

//BGM
let bgSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)

//効果音
var shotSound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
var hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
var sasaruSound = SKAction.playSoundFileNamed("sasaru.mp3", waitForCompletion: false)
var swordSound = SKAction.playSoundFileNamed("sword.mp3", waitForCompletion: false)
var nagarebosiSound = SKAction.playSoundFileNamed("nagarebosi.mp3", waitForCompletion: false)
var explodeSound = SKAction.playSoundFileNamed("explode.mp3", waitForCompletion: false)
var magicSound = SKAction.playSoundFileNamed("magic_circle.mp3", waitForCompletion: false)
var kiruSound = SKAction.playSoundFileNamed("kiru.mp3", waitForCompletion: false)

extension SKScene{
    
    /*
    度数からラジアンに変換するメソッド.
    */
    func degreeToRadian(degree : Double!) -> CGFloat{
        
        return CGFloat(degree) / CGFloat(180.0 * M_1_PI)
        
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    //モーション管理
    var motionManager: CMMotionManager!
    //タッチ開始ポイント
    var touchStartPoint: CGPoint! = nil
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
    
    
    //背景
    var bg = SKSpriteNode(imageNamed: "background2")
    //プレイヤー
    var player: SMPlayerNode!
    var playerTexture = SKTexture(imageNamed: "player1")
    var playerTexture2 = SKTexture(imageNamed: "player2")
    
    //剣
    var sword: SMSwordNode!
    
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
        bg.texture?.filteringMode = SKTextureFilteringMode.Nearest
        bg.anchorPoint = CGPoint(x:0.5, y:0) //中央に合わせる
        bg.zPosition = -100
        self.addChild(bg)
        //self.size = CGSize(width: 320, height: 568)
        //bg.size = self.size
        makeBgParticle()
        
        //背景を徐々に下にスクロールする
        var bgScrollAction = SKAction.moveToY(-60.0, duration: 10) //指定座標まで移動
        var bgScrollRevAction = SKAction.moveToY(0, duration: 10)
        var bgScroll = SKAction.repeatActionForever(SKAction.sequence([bgScrollAction,bgScrollRevAction]))
        bg.runAction(bgScroll)
        var scaleAction1 = SKAction.scaleTo(0.97, duration: 2)
        var scaleAction2 = SKAction.scaleTo(1.0, duration: 2)
        var scaleAction3 = SKAction.scaleTo(1.03, duration: 2)
        var scaleRepeat = SKAction.repeatActionForever(SKAction.sequence([scaleAction1,scaleAction2,scaleAction3]))
        bg.runAction(scaleRepeat)
        
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
        player = SMPlayerNode(texture: playerTexture)
        player.makePlayer(self,textures:[playerTexture,playerTexture2])
        
        //敵を作成する
        makeEnemySample()
        
        //BGMを鳴らす
        //let bgSoundRepeat = SKAction.repeatActionForever(bgSound)
        //self.runAction(bgSoundRepeat)
        
        //モーションセンサーを初期化する
        motionInit()
        
    }
    
    //モーションセンサーの初期化
    func motionInit() {
        //モーション管理を生成
        motionManager = CMMotionManager()
        
        //加速度の値を0.1秒ごとに取得する
        motionManager.accelerometerUpdateInterval = 0.1
        
        //ハンドラを設定する
        let accelerometerHandler: CMAccelerometerHandler = {
            (data:CMAccelerometerData!, error:NSError!) -> Void in
            
            //ログにx,y,zの加速度を表示する
            //println("x:\(data.acceleration.x),y:\(data.acceleration.y),z:\(data.acceleration.z)")
            
            if self.player == nil {
                return
            }
            
            //画面の範囲ならば
            //自機を移動する
            var positionx: CGFloat = 0.0
            var moveAction: SKAction!
            var tmpx: CGFloat = 0.0
            if self.player.position.x >= 0 && self.player.position.x <= self.frame.width {
                positionx = CGFloat(data.acceleration.x * 50)
                moveAction = SKAction.moveByX(positionx, y:self.player.position.y, duration: 0.1)
            } else {
                //画面端の場合はそれ以上進めないようにする
                if self.player.position.x <= 0 {
                    tmpx = 0
                } else if self.player.position.x >= self.frame.width {
                    tmpx = self.frame.width
                }
                moveAction = SKAction.moveToX(tmpx, duration: 0)
            }
            self.player.runAction(moveAction)
            
            //自機を傾ける
            var angle: CGFloat = CGFloat(positionx * -1) / CGFloat(180.0) * CGFloat(M_PI) ;
            //回転のアニメーション
            var rotateAction = SKAction.rotateToAngle(angle, duration: 0.1)
            self.player.runAction(SKAction.sequence([rotateAction]))
        }
        
        //センサー取得開始
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(),
        withHandler: accelerometerHandler)
    }
    
    
    //敵のサンプルを作る
    func makeEnemySample() {
        //enemysNode.removeAllChildren()
        for i in 0..<5 {
            makeEnemy1()
        }
    }
    
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameoverflg {
            //ゲームオーバの場合リスタート処理
            restart()
            return
        }
        //すでにタッチが開始されているなら何もしない
        if let tmp = touchStartPoint {
            return
        }
        for touch: AnyObject in touches {
            touchStartPoint = touch.locationInNode(self)
            //剣を作成する
            sword = SMSwordNode(texture:swordTexture, type:player.swordType, shotSound:shotSound, location:touchStartPoint, parentnode:swordsNode)
            sword.makeSword()
        }
    }
    
    //スワイプした時に呼び出される
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        //タッチが開始されていないのなら即リターン
        if touchStartPoint == nil {
            return
        }
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            sword.swipeSword(location)
        }
    }
    
    //タッチして指を離したときに呼び出される
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //タッチが開始されていないのなら即リターン
        if touchStartPoint == nil {
            return
        }
        for touch: AnyObject in touches {
            //let location = touch.locationInNode(self)
            //剣を発射する
            sword.shotSword()
            sword = nil
            touchStartPoint = nil
        }
    }
    
    //ゲームのリスタート処理
    func restart() {
        //スコアを0にする
        score = 0
        scoreLabel.text = "\(score)"
        
        //ゲームオーバラベルを消す
        
        //フラグを戻す
        gameoverflg = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if makeenemyflg {
            makeenemyflg = false
            makeEnemySample()
        }
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
        var action = SKAction.moveTo(player.position, duration: 20)
        enemy1.runAction(action)
        
        //ずっとプレイヤーの方向を向くようにする
        // 姿勢へのConstraintsを作成.
        //let cons = SKConstraint.orientToPoint(player.position,offset: SKRange(constantValue: degreeToRadian(-90)))
        //enemy1.constraints = [cons]
        
        //回転のアニメーションをランダム時間で付ける
        var rotateAction = SKAction.rotateByAngle(CGFloat(360*M_PI/180), duration: 0.5)
        var rotateWaitAction = SKAction.waitForDuration(NSTimeInterval(CGFloat(randY) * 0.05))
        var rotate = SKAction.repeatActionForever(SKAction.sequence([rotateAction,rotateWaitAction]))
        enemy1.runAction(rotate)
    }
    
    //衝突判定
    func didBeginContact(contact: SKPhysicsContact) {
        //すでにゲームオーバーだったら即リターン
        if gameoverflg {
            return
        }
        let swordType = ColliderType.Sword
        let enemyType = ColliderType.Enemy
        let playerType = ColliderType.Player
        if (contact.bodyA.categoryBitMask & swordType == swordType ||
            contact.bodyB.categoryBitMask & swordType == swordType ) {
            //剣の衝突
            //敵に剣が当たったら消す
            if (contact.bodyA.categoryBitMask & enemyType == enemyType) {
                contact.bodyB.categoryBitMask = ColliderType.None
                self.runAction(sasaruSound)
                killEnemy(contact.bodyA.node)
            } else if (contact.bodyB.categoryBitMask & enemyType == enemyType) {
                contact.bodyA.categoryBitMask = ColliderType.None
                self.runAction(sasaruSound)
                killEnemy(contact.bodyB.node)
            } else if contact.bodyA.categoryBitMask & ColliderType.None == ColliderType.None ||
                contact.bodyB.categoryBitMask & ColliderType.None == ColliderType.None {
                //剣と剣の衝突
                //contact.bodyA.categoryBitMask = ColliderType.None
                //contact.bodyB.categoryBitMask = ColliderType.None
                self.runAction(swordSound)
            }
        } else if contact.bodyA.categoryBitMask & playerType == playerType ||
            contact.bodyB.categoryBitMask & playerType == playerType {
            //プレイヤーとの衝突
            
            //敵とプレイヤーが衝突したらゲームオーバー
            if contact.bodyA.categoryBitMask & enemyType == enemyType {
                gameover()
            } else if contact.bodyB.categoryBitMask & enemyType == enemyType {
                gameover()
            }
        }
    }
    
    //ゲームオーバーの処理
    func gameover() {
        //フラグをtrueにする
        gameoverflg = true
        
        //敵の停止
        enemysNode.speed = 0.0
        
        //ラベル表示
        gameoverLabel.text = "Gameover"
        gameoverLabel.fontSize = 25
        gameoverLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        gameoverLabel.zPosition = 1000
        self.addChild(gameoverLabel)
        gameoverLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        
        //やられた効果音再生
        self.runAction(explodeSound)
        
        //やられたアニメーション作成
        
        //プレイヤーのアニメーション削除
        
        //プレイヤー削除
        fadeRemoveNode(player)
    }
    
    //敵を倒した時の処理
    func killEnemy(enemynode: SKNode!) {
        enemynode.physicsBody?.categoryBitMask = ColliderType.None
        enemynode.removeAllActions()
        makeHitParticle(enemynode.position,node:self)
        //self.runAction(hitSound)
        killcount++
        score += 10
        scoreLabel.text = "\(score)"
        if killcount % 5 == 0 {
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
    //攻撃ヒットのパーティクルを作る
    func makeHitParticle(point:CGPoint,node:SKNode) {
        makeParticleNode(point, filename:"hitParticle.sks", node:node)
    }
    //敵消滅のパーティクルを作る
    func makeKillParticle(node:SKNode) {
        let point: CGPoint = CGPoint(x:0, y:0)
        makeParticleNode(point, filename:"MyParticle.sks", node:node)
        self.runAction(hitSound) //消滅の効果音を鳴らす
    }
    
    //パーティクル発生
    func makeParticle(position:CGPoint?, filename: String, hide: Bool = true) {
        makeParticleNode(position, filename: filename, hide: hide, node: self)
    }
    func makeParticleNode(position:CGPoint?, filename: String, hide: Bool = true, node: SKNode) {
        SMNodeUtil.makeParticleNode(position, filename: filename, hide: hide, node: node)
    }
    
    //一秒後にフェードしながらノードを消す
    func fadeRemoveNode(removenode: SKNode!) {
        SMNodeUtil.fadeRemoveNode(removenode)
    }
    
}
