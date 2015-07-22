//
//  GameScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit
import CoreMotion

//プレイヤー
var player: SMPlayerNode!

//ステータス欄
var statusNode: SKNode = SKNode()

//すべてのベースノード
var world: SKNode = SKNode()

//背景用ノード
var bgNode: SKNode = SKNode()

//敵配置用ノード
var enemysNode = SKNode()

//剣配置用ノード
var swordsNode = SKNode()

//BGM
let stage1BgSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)

//背景
var stage1Background = SKSpriteNode(imageNamed: "background2")

//効果音
var hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
var sasaruSound = SKAction.playSoundFileNamed("sasaru.mp3", waitForCompletion: false)
var swordSound = SKAction.playSoundFileNamed("sword.mp3", waitForCompletion: false)
var nagarebosiSound = SKAction.playSoundFileNamed("nagarebosi.mp3", waitForCompletion: false)
var explodeSound = SKAction.playSoundFileNamed("explode.mp3", waitForCompletion: false)
var magicSound = SKAction.playSoundFileNamed("magic_circle.mp3", waitForCompletion: false)
var kiruSound = SKAction.playSoundFileNamed("kiru.mp3", waitForCompletion: false)

//テクスチャ
var swordIconTexture = SKTexture(imageNamed: "sword_icon")

//ラベル
let gameoverLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
let scoreLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")

//スコア
var totalScore: Int = 0

//ステージファクトリ
let stageFactory: SMStageFactory = SMStageFactory()
//敵ファクトリ
let enemyFactory: SMEnemyFactory = SMEnemyFactory()
let enegyFactory: SMEnegyFactory = SMEnegyFactory()
//剣ファクトリ
let swordFactory: SMSwordFactory = SMSwordFactory()

//フレーム幅
var frameWidth: CGFloat!
//フレーム高さ
var frameHeight: CGFloat!

//ステージ管理
var stageManager: SMStageManage = SMStageManage()


extension SKScene{
    
    /*
    度数からラジアンに変換するメソッド.
    */
    class func degreeToRadian(degree : Double!) -> CGFloat{
        
        return CGFloat(degree) / CGFloat(180.0 * M_1_PI)
        
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    //モーション管理
    var motionManager: CMMotionManager!
    //タッチ開始ポイント
    var touchStartPoint: CGPoint! = nil
    
    //ゲームオーバーフラグ
    var gameoverflg = false
    //敵作成フラグ
    var makeenemyflg = false
    
    //敵を倒した数
    var killcount = 0
    
    //プレイヤーテクスチャ
    var playerTexture = SKTexture(imageNamed: "player1")
    var playerTexture2 = SKTexture(imageNamed: "player2")
    
    //剣
    var sword: SMSwordNode!
    
    //カメラ
    var camera: SKNode = SKNode()
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //self.anchorPoint = CGPointMake(0.5, 0.5)
        //大本のノード
        world.name = "world"
        self.addChild(world)
        
        //カメラを設定する
        camera.name = "camera"
        world.addChild(camera)
        
        frameWidth = self.frame.width
        frameHeight = self.frame.height
        
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-0.10)
        self.physicsWorld.contactDelegate = self
        
        //ラベルの表示
        scoreLabel.text = "\(totalScore)"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scoreLabel.zPosition = 1000
        self.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height - 30)
        
        //背景管理用ノード
        bgNode.position = CGPoint(x:0, y:0)
        world.addChild(bgNode)
        bgNode.zPosition = -100
        
        //剣配置用ノード
        swordsNode.position = CGPoint(x:0, y:0)
        self.addChild(swordsNode)
        swordsNode.zPosition = 2
        
        //敵配置用ノード
        enemysNode.position = CGPoint(x:0, y:0)
        world.addChild(enemysNode)
        enemysNode.zPosition = 2
        
        
        //プレイヤーを作成
        player = SMPlayerNode(texture: playerTexture)
        player.makePlayer(self,textures:[playerTexture,playerTexture2])
        
        //ステータス
        statusNode.zPosition = 1000
        statusNode.position = CGPoint(x: 10, y: 10)
        self.addChild(statusNode)
        
        //敵を作成する
        //makeEnemySample()
        
        //BGMを鳴らす
        //let bgSoundRepeat = SKAction.repeatActionForever(bgSound)
        //self.runAction(bgSoundRepeat)
        
        //モーションセンサーを初期化する
        motionInit()
        
        //ステージの作成処理
        stageManager.makeStage()
    }
    
    //カメラの移動処理
    override func didSimulatePhysics(){
        var camera:SKNode = self.childNodeWithName("//camera")!
        camera.position = CGPointMake(player.position.x - self.frame.width/2, camera.position.y)
        self.centerOnNode(camera)
    }
    func centerOnNode(node:SKNode) {
        if let scene:SKScene = node.scene
        {
            var cameraPositionInScene:CGPoint = scene.convertPoint(node.position, fromNode: node.parent!)
            node.parent!.position = CGPointMake(node.parent!.position.x - cameraPositionInScene.x,                                       node.parent!.position.y - cameraPositionInScene.y);
        }
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
            
            if player == nil {
                return
            }
            
            //画面の範囲ならば
            //自機を移動する
            var positionx: CGFloat = 0.0
            var moveAction: SKAction!
            var tmpx: CGFloat = 0.0
            if player.position.x >= 0 && player.position.x <= self.frame.width {
                positionx = CGFloat(data.acceleration.x * 20)
                moveAction = SKAction.moveByX(positionx, y:player.position.y, duration: 0.1)
            } else {
                //画面端の場合はそれ以上進めないようにする
                if player.position.x <= 0 {
                    tmpx = 0
                } else if player.position.x >= self.frame.width {
                    tmpx = self.frame.width
                }
                moveAction = SKAction.moveToX(tmpx, duration: 0.1)
            }
            player.runAction(moveAction)
            
            //自機を傾ける
            var angle: CGFloat = CGFloat(positionx * -1) / CGFloat(180.0) * CGFloat(M_PI) ;
            //回転のアニメーション
            var rotateAction = SKAction.rotateToAngle(angle, duration: 0.1)
            player.runAction(SKAction.sequence([rotateAction]))
        }
        
        //センサー取得開始
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(),
        withHandler: accelerometerHandler)
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
        if player.swordNum <= 0 {
            return
        }
        for touch: AnyObject in touches {
            var touchPoint = touch.locationInNode(self)
            if touchPoint.y > 300 {
                continue
            }
            player.countDownSword()
            touchStartPoint = touchPoint
            //剣を作成する
            let randtype = randomSwordType()
            sword = swordFactory.create(randtype, position: touchStartPoint)
            //sword = SMSwordNode(texture:swordTexture, type: player.swordType, shotSound:shotSound, location:touchStartPoint, parentnode:swordsNode)
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
        /*
        //スコアを0にする
        totalScore = 0
        scoreLabel.text = "\(totalScore)"
        
        //ゲームオーバラベルを消す
        
        //フラグを戻す
        gameoverflg = false
*/
        scoreLabel.removeAllActions()
        scoreLabel.removeAllChildren()
        scoreLabel.removeFromParent()
        bgNode.removeAllActions()
        bgNode.removeAllChildren()
        bgNode.removeFromParent()
        enemysNode.removeAllActions()
        enemysNode.removeAllChildren()
        enemysNode.removeFromParent()
        swordsNode.removeAllActions()
        swordsNode.removeAllChildren()
        swordsNode.removeFromParent()
        world.removeAllActions()
        world.removeAllChildren()
        world.removeFromParent()
        statusNode.removeAllActions()
        statusNode.removeAllChildren()
        statusNode.removeFromParent()
        
        enemysNode.speed = 1.0
        
        //タイトル画面表示
        let scene = GameTitleScene()
        
        // Configure the view.
        let skView = self.view! as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        skView.presentScene(scene)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /*
        if makeenemyflg {
            makeenemyflg = false
            makeEnemySample()
        }
*/
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
                let enemy: SMEnemyNode = contact.bodyA.node as! SMEnemyNode
                let sword: SMSwordNode = contact.bodyB.node as! SMSwordNode
                enemy.hitSword(sword)
            } else if (contact.bodyB.categoryBitMask & enemyType == enemyType) {
                let enemy: SMEnemyNode = contact.bodyB.node as! SMEnemyNode
                let sword: SMSwordNode = contact.bodyA.node as! SMSwordNode
                enemy.hitSword(sword)
            } else if contact.bodyA.categoryBitMask & ColliderType.None == ColliderType.None ||
                contact.bodyB.categoryBitMask & ColliderType.None == ColliderType.None {
                //剣とNoneの衝突
                //self.runAction(swordSound)
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
        stageManager.currentStage.audioPlayer?.stop()
        
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
        SMNodeUtil.makeParticleNode(player.position, filename: "deadParticle.sks", hide: true, node: bgNode)
        
        //プレイヤー削除
        fadeRemoveNode(player)
    }
    
    /*
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
    
    //攻撃ヒットのパーティクルを作る
    func makeHitParticle(point:CGPoint,node:SKNode) {
        makeParticleNode(point, filename:"hitParticle.sks", node:node)
    }
*/
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
