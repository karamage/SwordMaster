//
//  GameScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit
import CoreMotion

//デバッグモード
var debugflg: Bool = true

//プレイヤー
var player: SMPlayerNode!

var combo: Int = 0 //コンボ数

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

//ヒットアニメーション
var hitAim: [SKTexture]!

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
let comboLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
let returnLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")

//スコア
var totalScore: Int = 0

//ステージファクトリ
let stageFactory: SMStageFactory = SMStageFactory()
//敵ファクトリ
let enemyFactory: SMEnemyFactory = SMEnemyFactory()
let enegyFactory: SMEnegyFactory = SMEnegyFactory()
//剣ファクトリ
let swordFactory: SMSwordFactory = SMSwordFactory()
//アイテムファクトリ
let itemFactory: SMItemFactory = SMItemFactory()

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
        
        //スコアラベルの表示
        scoreLabel.text = "\(totalScore)"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        scoreLabel.zPosition = 1000
        self.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: (self.frame.size.width/2) - 100, y: self.frame.size.height - 30)
        
        //コンボラベルの表示
        comboLabel.text = "\(combo) Combo!"
        comboLabel.fontSize = 25
        comboLabel.alpha = 0.0
        comboLabel.fontColor = UIColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 0.9)
        comboLabel.zPosition = 1000
        self.addChild(comboLabel)
        comboLabel.position = CGPoint(x: self.frame.size.width - 100, y: self.frame.size.height - 30)
        
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
        
        //hitのアニメーションを切り出す
        hitAim = SMAnimationUtil.explodeAnime("hiteffect", xFrame: 5, yFrame: 6)
        
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
            for touch: AnyObject in touches {
                var touchPoint = touch.locationInNode(self)
                let node: SKNode! =  self.nodeAtPoint(touchPoint)
                if let tmpnode = node {
                    if tmpnode.name == "returnLabel" {
                        //ゲームオーバの場合リスタート処理
                        restart()
                        return
                    }
                }
            }
            return
        }
        //すでにタッチが開始されているなら何もしない
        if let tmp = touchStartPoint {
            return
        }
        for touch: AnyObject in touches {
            var touchPoint = touch.locationInNode(self)
            if touchPoint.y > 300 {
                continue
            }
            if player.swordNum <= 0 {
                //魔法陣が開いてすぐ閉じる演出
                let randtype = randomSwordType()
                let tmpsword = swordFactory.create(randtype, position: touchPoint)
                tmpsword?.circle.color = UIColor.redColor()
                tmpsword?.circle.colorBlendFactor = 0.5
                tmpsword!.makeCircle(touchPoint)
                tmpsword!.removeCircle()
                return
            }
            player.countDownSword()
            touchStartPoint = touchPoint
            //剣を作成する
            let randtype = randomSwordType()
            sword = swordFactory.create(randtype, position: touchStartPoint)
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
        scoreLabel.removeAllActions()
        scoreLabel.removeAllChildren()
        scoreLabel.removeFromParent()
        comboLabel.removeAllActions()
        comboLabel.removeAllChildren()
        comboLabel.removeFromParent()
        gameoverLabel.removeAllActions()
        gameoverLabel.removeAllChildren()
        gameoverLabel.removeFromParent()
        returnLabel.removeAllActions()
        returnLabel.removeAllChildren()
        returnLabel.removeFromParent()
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
        let enegyType = ColliderType.Enegy
        let itemType = ColliderType.Item
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
                //なにもしない
            } else if contact.bodyA.categoryBitMask & itemType == itemType ||
                contact.bodyB.categoryBitMask & itemType == itemType {
                if contact.bodyA.categoryBitMask & itemType == itemType {
                    let item: SMItemNode = contact.bodyA.node as! SMItemNode
                    let sword: SMSwordNode = contact.bodyB.node as! SMSwordNode
                    item.contactSword(sword)
                } else if contact.bodyB.categoryBitMask & itemType == itemType {
                    let item: SMItemNode = contact.bodyB.node as! SMItemNode
                    let sword: SMSwordNode = contact.bodyA.node as! SMSwordNode
                    item.contactSword(sword)
                }
            } else if contact.bodyA.categoryBitMask & enegyType == enegyType ||
                contact.bodyB.categoryBitMask & enegyType == enegyType {
                if contact.bodyA.categoryBitMask & enegyType == enegyType {
                    let enegy: SMEnegyNode = contact.bodyA.node as! SMEnegyNode
                    let sword: SMSwordNode = contact.bodyB.node as! SMSwordNode
                    enegy.contactSword(sword)
                } else if contact.bodyB.categoryBitMask & enegyType == enegyType {
                    let enegy: SMEnegyNode = contact.bodyB.node as! SMEnegyNode
                    let sword: SMSwordNode = contact.bodyA.node as! SMSwordNode
                    enegy.contactSword(sword)
                }
            }
        } else if contact.bodyA.categoryBitMask & playerType == playerType ||
            contact.bodyB.categoryBitMask & playerType == playerType {
            //プレイヤーとの衝突
            
            if contact.bodyA.categoryBitMask & enemyType == enemyType ||
               contact.bodyB.categoryBitMask & enemyType == enemyType {
                if debugflg {
                    return
                }
                //敵とプレイヤーが衝突したらゲームオーバー
                player.deadPlayer()
                gameover()
            } else if contact.bodyA.categoryBitMask & enegyType == enegyType ||
                contact.bodyB.categoryBitMask & enegyType == enegyType {
                if debugflg {
                    return
                }
                //敵の弾を被弾した場合
                var enegy: SMEnegyNode!
                if contact.bodyA.categoryBitMask & enegyType == enegyType {
                    enegy = contact.bodyA.node as! SMEnegyNode
                } else if contact.bodyB.categoryBitMask & enegyType == enegyType {
                    enegy = contact.bodyB.node as! SMEnegyNode
                }
                player.damegedEnegy(enegy)
                if player.hitpoint <= 0 {
                    player.deadPlayer()
                    gameover()
                }
            } else if contact.bodyA.categoryBitMask & itemType == itemType ||
                contact.bodyB.categoryBitMask & itemType == itemType {
                    var item: SMItemNode!
                if contact.bodyA.categoryBitMask & itemType == itemType {
                    item = contact.bodyA.node as! SMItemNode
                } else if contact.bodyB.categoryBitMask & itemType == itemType {
                    item = contact.bodyB.node as! SMItemNode
                }
                player.contactItem(item)
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
        gameoverLabel.text = "GAMEOVER"
        gameoverLabel.fontSize = 30
        gameoverLabel.fontColor = UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 0.9)
        gameoverLabel.zPosition = 1000
        self.addChild(gameoverLabel)
        gameoverLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        
        //ラベル表示
        returnLabel.text = "タイトル画面に戻る"
        returnLabel.name = "returnLabel"
        returnLabel.fontSize = 25
        //returnLabel.color = UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0)
        //returnLabel.colorBlendFactor = 1.0
        returnLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        returnLabel.zPosition = 1000
        self.addChild(returnLabel)
        returnLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2 - 100)
    }
    
    /*
    //敵消滅のパーティクルを作る
    func makeKillParticle(node:SKNode) {
        let point: CGPoint = CGPoint(x:0, y:0)
        makeParticleNode(point, filename:"MyParticle.sks", node:node)
        self.runAction(hitSound) //消滅の効果音を鳴らす
    }
*/
    
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
