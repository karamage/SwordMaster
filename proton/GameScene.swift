//
//  GameScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//
//  2015 8/18 v1.0 AppStore release
//  2015 8/18 v1.1 開発開始

import SpriteKit
import CoreMotion

//デバッグモード
var debugflg: Bool = false

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
var stage2Background = SKSpriteNode(imageNamed: "background_sora2")
var stage3Background = SKSpriteNode(imageNamed: "background3")

//ヒットアニメーション
var hitAim: [SKTexture]!

//ガードアニメーション
var guardAim: [SKTexture]!
var guardAnimAction = SKAction.animateWithTextures(guardAim, timePerFrame: 0.1, resize:false, restore:true)

//切るアニメーション
var killAim: [SKTexture]!
var killAimNode: SKSpriteNode!

//操作アニメーション
var moveAim: [SKTexture]!
var tapAim: [SKTexture]!
var swipeAim: [SKTexture]!

//効果音
var hitSound:SKAction!
var sasaruSound:SKAction!
var swordSound:SKAction!
var nagarebosiSound:SKAction!
var explodeSound:SKAction!
var explodeSound2:SKAction!
var magicSound:SKAction!
var kiruSound:SKAction!
var kuraeSound:SKAction!
var konoSound:SKAction!
var sokodaSound:SKAction!
var toryaSound:SKAction!
var eiSound:SKAction!
var yaaSound:SKAction!
var powerupSound:SKAction!
var itemgetSound:SKAction!
var comboSound:SKAction!
var hawawaSound:SKAction!
var mataSound:SKAction!
var koredeSound:SKAction!
var kakinSound:SKAction!
var fadeSound:SKAction!
var choroiSound:SKAction!

//テクスチャ
var swordIconTexture = SKTexture(imageNamed: "sword_icon")
var tapTexture = SKTexture(imageNamed: "tap")
var guardTexture = SKTexture(imageNamed: "guard1")
var guard2Texture = SKTexture(imageNamed: "guard2")

//ラベル
var gameoverLabel:SKLabelNode!
var scoreLabel:SKLabelNode!
var comboLabel:SKLabelNode!
var returnLabel:SKLabelNode!
var helpLabel:SKLabelNode!
var helpLabel2:SKLabelNode!
var helpLabel3:SKLabelNode!
var helpLabel4:SKLabelNode!

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

//プレイヤーテクスチャ
var playerTexture = SKTexture(imageNamed: "player1")
var playerTexture2 = SKTexture(imageNamed: "player2")

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
    //がんばります
    var ganbarimasuSound = SKAction.playSoundFileNamed("ganbarimasu_01.mp3", waitForCompletion: false)
    //カットイン
    var cutin1 = SKSpriteNode(imageNamed: "cutin1")
    
    //ソーシャルボタン
    let twButton = SKSpriteNode(imageNamed:"twitter_icon")
    let fbButton = SKSpriteNode(imageNamed:"facebook_icon")
    var touchButtonName:String? = ""
    
    //ゲームオーバーフラグ
    var gameoverflg = false
    //敵作成フラグ
    var makeenemyflg = false
    
    //敵を倒した数
    var killcount = 0
    
    
    //剣
    var sword: SMSwordNode!
    var optionSwords: [SMSwordNode] = [SMSwordNode]()
    
    //カメラ
    var camera_tmp: SKNode = SKNode()
    
    func cutin() {
        cutin1.removeFromParent()
        cutin1.removeAllActions()
        cutin1.position = CGPoint(x: self.frame.width + 10, y: self.frame.height / 2)
        cutin1.alpha = 0.0
        cutin1.zPosition = 10
        self.addChild(cutin1)
        let resetScale = SKAction.scaleTo(1.2, duration: 0.0)
        let moveAction1 = SKAction.moveToX(self.frame.width / 2, duration: 0.5)
        let scaleAction = SKAction.scaleBy(1.5, duration: 0.5)
        let waitAction = SKAction.waitForDuration(0.5)
        let moveAction2 = SKAction.moveToX(0.0, duration: 0.5)
        cutin1.runAction(SKAction.sequence([resetScale, moveAction1, scaleAction, waitAction, moveAction2]))
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let removeAction = SKAction.removeFromParent()
        cutin1.runAction(SKAction.sequence([fadeIn,waitAction,fadeOut,removeAction]))
        SMNodeUtil.makeParticleNode(CGPoint(x: 0.0, y: 0.0), filename: "cutinParticle.sks", hide: true, node: cutin1)
    }
    
    //操作説明を表示する
    func howto() {
        //タップして剣を撃つ操作説明
        let tap = SKSpriteNode(texture: tapTexture)
        tap.zPosition = 1000
        tap.position = CGPoint(x: self.frame.width/2 + 100, y: self.frame.height/2 - 150)
        tap.alpha = 0.0
        self.addChild(tap)
        
        let waitAction = SKAction.waitForDuration(2.0)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let scale1 = SKAction.scaleTo(1.2, duration: 0.0)
        let scale2 = SKAction.scaleTo(1.0, duration: 0.5)
        let tapAction = SKAction.sequence([waitAction, fadeInAction, scale1, scale2, scale1, scale2, scale1, scale2, fadeOutAction])
        
        //ラベルの表示
        helpLabel.text = "自機周辺をタップすると剣を撃ちます"
        helpLabel.fontSize = 18
        helpLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        helpLabel.zPosition = 1000
        helpLabel.alpha = 0.0
        self.addChild(helpLabel)
        helpLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        let tapLabelAction = SKAction.sequence([waitAction, fadeInAction, waitAction, fadeOutAction])
        helpLabel.runAction(SKAction.sequence([tapLabelAction,SKAction.removeFromParent()]))
        
        //タップ領域の説明
        if #available(iOS 8.0, *) {
            let shape:SKShapeNode = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: 300))
            shape.fillColor = UIColor.whiteColor()
            shape.alpha = 0.05
            self.addChild(shape)
            shape.position = CGPoint(x:self.frame.width/2, y: 150)
            let scale0 = SKAction.scaleTo(0.0, duration: 0.0)
            let scale3 = SKAction.scaleTo(1.0, duration: 1.0)
            let shapeAction = SKAction.sequence([scale0, scale3])
            let repeatShape = SKAction.repeatAction(shapeAction,count:7)
            shape.runAction(SKAction.sequence([scale0, waitAction, repeatShape, SKAction.removeFromParent()]))
        } else {
            // Fallback on earlier versions
        }
        
        //移動の操作説明
        moveAim = SMAnimationUtil.explodeAnime("moveAnim", xFrame: 2, yFrame: 1)
        let moveAnimAction = SKAction.animateWithTextures(moveAim, timePerFrame: 1.0)
        let repeatMove = SKAction.repeatAction(moveAnimAction, count: 3)
        let moveAction = SKAction.sequence([waitAction,fadeInAction, repeatMove, fadeOutAction])
        
        //長押しタップの説明
        tapAim = SMAnimationUtil.explodeAnime("tap", xFrame: 1, yFrame: 1)
        let lscale2 = SKAction.scaleTo(1.5, duration: 1.5)
        let ltapAnimAction = SKAction.animateWithTextures(tapAim, timePerFrame: 0.1)
        let ltapAction = SKAction.sequence([waitAction, ltapAnimAction, fadeInAction, scale1, lscale2, scale1, lscale2, scale1, lscale2, fadeOutAction])
        
        //スワイプの説明
        swipeAim = SMAnimationUtil.explodeAnime("swipe", xFrame: 2, yFrame: 1)
        let swipeAnimAction = SKAction.animateWithTextures(swipeAim, timePerFrame: 1.0)
        let repeatSwipe = SKAction.repeatAction(swipeAnimAction, count: 3)
        let swipeAction = SKAction.sequence([waitAction,scale1,fadeInAction, repeatSwipe, fadeOutAction])
        
        
        let allAction = SKAction.sequence([tapAction,moveAction,ltapAction,swipeAction])
        tap.runAction(allAction)
        
        //移動のラベルの説明
        let waitAction7 = SKAction.waitForDuration(7.0)
        helpLabel2.text = "画面を傾けると自機が左右に移動します"
        helpLabel2.fontSize = 18
        helpLabel2.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        helpLabel2.zPosition = 1000
        helpLabel2.alpha = 0.0
        self.addChild(helpLabel2)
        helpLabel2.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        helpLabel2.runAction(SKAction.sequence([waitAction7, tapLabelAction,SKAction.removeFromParent()]))
        
        //長押しタップのラベル説明
        helpLabel3.text = "長押しタップでタメ撃ちします"
        helpLabel3.fontSize = 20
        helpLabel3.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        helpLabel3.zPosition = 1000
        helpLabel3.alpha = 0.0
        self.addChild(helpLabel3)
        helpLabel3.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        helpLabel3.runAction(SKAction.sequence([waitAction7, waitAction7,tapLabelAction,SKAction.removeFromParent()]))
        
        //スワイプのラベル説明
        helpLabel4.text = "スワイプで剣の発射角度が変わります"
        helpLabel4.fontSize = 18
        helpLabel4.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        helpLabel4.zPosition = 1000
        helpLabel4.alpha = 0.0
        self.addChild(helpLabel4)
        helpLabel4.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height/2)
        helpLabel4.runAction(SKAction.sequence([waitAction7, waitAction7,waitAction7,tapLabelAction,SKAction.removeFromParent()]))
    }
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //self.anchorPoint = CGPointMake(0.5, 0.5)
        //大本のノード
        world.name = "world"
        self.addChild(world)
        
        //カメラを設定する
        camera_tmp.name = "camera"
        world.addChild(camera_tmp)
        
        frameWidth = self.frame.width
        frameHeight = self.frame.height
        
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-0.10)
        self.physicsWorld.contactDelegate = self
        
        hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
        sasaruSound = SKAction.playSoundFileNamed("sasaru.mp3", waitForCompletion: false)
        swordSound = SKAction.playSoundFileNamed("sword.mp3", waitForCompletion: false)
        nagarebosiSound = SKAction.playSoundFileNamed("nagarebosi.mp3", waitForCompletion: false)
        explodeSound = SKAction.playSoundFileNamed("explode.mp3", waitForCompletion: false)
        explodeSound2 = SKAction.playSoundFileNamed("explode2.mp3", waitForCompletion: false)
        magicSound = SKAction.playSoundFileNamed("magic_circle.mp3", waitForCompletion: false)
        kiruSound = SKAction.playSoundFileNamed("kiru.mp3", waitForCompletion: false)
        kuraeSound = SKAction.playSoundFileNamed("kurae_01.mp3", waitForCompletion: false)
        konoSound = SKAction.playSoundFileNamed("kono_01.mp3", waitForCompletion: false)
        sokodaSound = SKAction.playSoundFileNamed("sokoda_01.mp3", waitForCompletion: false)
        toryaSound = SKAction.playSoundFileNamed("torya_01.mp3", waitForCompletion: false)
        eiSound = SKAction.playSoundFileNamed("ei_01.mp3", waitForCompletion: false)
        yaaSound = SKAction.playSoundFileNamed("yaa_01.mp3", waitForCompletion: false)
        powerupSound = SKAction.playSoundFileNamed("powerup_01.mp3", waitForCompletion: false)
        itemgetSound = SKAction.playSoundFileNamed("itemget_01.mp3", waitForCompletion: false)
        comboSound = SKAction.playSoundFileNamed("combo_01.mp3", waitForCompletion: false)
        hawawaSound = SKAction.playSoundFileNamed("hawawa_01.mp3", waitForCompletion: false)
        mataSound = SKAction.playSoundFileNamed("mataaeruyone_01.mp3", waitForCompletion: false)
        koredeSound = SKAction.playSoundFileNamed("korededouda_01.mp3", waitForCompletion: false)
        kakinSound = SKAction.playSoundFileNamed("kakin.mp3", waitForCompletion: false)
        fadeSound = SKAction.playSoundFileNamed("fade.mp3", waitForCompletion: false)
        choroiSound = SKAction.playSoundFileNamed("choroimondane_01.mp3", waitForCompletion: false)
        
        gameoverLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        scoreLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        comboLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        returnLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        helpLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        helpLabel2 = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        helpLabel3 = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        helpLabel4 = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        totalScore = 0
        
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
        bgNode.removeAllActions()
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
        guardAim = SMAnimationUtil.explodeAnime("guard", xFrame: 5, yFrame: 2)
        
        killAim = SMAnimationUtil.explodeAnime("kill", xFrame: 1, yFrame: 10)
        
        //モーションセンサーを初期化する
        motionInit()
        
        //ステージの作成処理
        stageManager.makeStage()
        
        cutin()
        let waitAction = SKAction.waitForDuration(0.5)
        bgNode.runAction(SKAction.sequence([waitAction,ganbarimasuSound]))
        //self.runAction(SKAction.sequence([waitAction,ganbarimasuSound]))
        //self.runAction(SKAction.sequence([waitAction,ganbarimasuSound]))
        
        killAimNode = SKSpriteNode(texture: killAim[0])
        killAimNode.zPosition = 100
        killAimNode.position = CGPoint(x:self.frame.width/2, y:self.frame.height/2 + 200)
        killAimNode.blendMode = SKBlendMode.Add
        killAimNode.alpha = 0.0
        self.addChild(killAimNode)
        
        howto()
    }
    
    //カメラの移動処理
    override func didSimulatePhysics(){
        let camera:SKNode = self.childNodeWithName("//camera")!
        camera.position = CGPointMake(player.position.x - self.frame.width/2, camera.position.y)
        self.centerOnNode(camera)
    }
    func centerOnNode(node:SKNode) {
        if let scene:SKScene = node.scene
        {
            let cameraPositionInScene:CGPoint = scene.convertPoint(node.position, fromNode: node.parent!)
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
            (data:CMAccelerometerData?, error:NSError?) -> Void in
            
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
            let speed: CGFloat = 1.0 + (0.1 * CGFloat(player.speedup))
            if player.position.x >= 0 && player.position.x <= self.frame.width {
                positionx = CGFloat(CGFloat(data!.acceleration.x) * CGFloat(20.0) * speed)
                moveAction = SKAction.moveByX(positionx, y:0, duration: 0.1)
            } else {
                //画面端の場合はそれ以上進めないようにする
                if player.position.x <= 0 {
                    tmpx = 10
                } else if player.position.x >= self.frame.width {
                    tmpx = self.frame.width - 10
                }
                moveAction = SKAction.moveToX(tmpx, duration: 0.1)
            }
            player.runAction(moveAction)
            
            //自機を傾ける
            let angle: CGFloat = CGFloat(positionx * -1) / CGFloat(180.0) * CGFloat(M_PI) ;
            //回転のアニメーション
            let rotateAction = SKAction.rotateToAngle(angle, duration: 0.1)
            player.runAction(SKAction.sequence([rotateAction]))
        }
        
        let que = NSOperationQueue.currentQueue()
        
        //センサー取得開始
        motionManager.startAccelerometerUpdatesToQueue(que!,
        withHandler: accelerometerHandler)
    }
    
    // Twitter/Facebookボタンがタップされたとき
    func socialButtonTapped(social:String){
        
        // share画面で表示するメッセージを格納
        var message = String()
        //if social == "twitter" {
            message = "score:" + String(totalScore) + " #SMYuusuke"
        /*
        } else {
            message = "Facebook Share"
        }
*/
        
        // userinfoに情報(socialの種類とmessage)を格納
        let userInfo = ["social": social.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,"message": message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!]
        
        // userInfoも含めて、"socialShare"という名称の通知をここで飛ばす
        NSNotificationCenter.defaultCenter().postNotificationName("socialShare", object: nil, userInfo: userInfo)
        
    }
    
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if gameoverflg {
            for touch: AnyObject in touches {
                let touchPoint = touch.locationInNode(self)
                let node: SKNode! =  self.nodeAtPoint(touchPoint)
                if let tmpnode = node {
                    if tmpnode.name == "returnLabel" {
                        //ゲームオーバの場合リスタート処理
                        restart()
                        return
                    }
                    let location = touch.locationInNode(self)
                    touchButtonName = nodeAtPoint(location).name
                    if (touchButtonName == "twitter_button") {
                        socialButtonTapped("twitter")
                    } else if (touchButtonName == "facebook_button") {
                        socialButtonTapped("facebook")
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
            let touchPoint = touch.locationInNode(self)
            if touchPoint.y > 300 {
                continue
            }
            if player.swordNum <= 0 {
                //魔法陣が開いてすぐ閉じる演出
                let randtype = randomSwordType()
                let tmpsword = swordFactory.create(randtype, position: touchPoint, startPoint:touchPoint)
                tmpsword?.circle.color = UIColor.redColor()
                tmpsword?.circle.colorBlendFactor = 0.5
                tmpsword!.makeCircle(touchPoint)
                tmpsword!.removeCircle()
                bgNode.runAction(hawawaSound)
                return
            }
            player.countDownSword()
            touchStartPoint = touchPoint
            //剣を作成する
            let randtype = randomSwordType()
            sword = swordFactory.create(randtype, position: touchStartPoint, startPoint: touchStartPoint)
            sword.makeSword()
            
            //オプションの剣の作成を行う
            let waitAction = SKAction.waitForDuration(0.5)
            weak var tmpself = self
            let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
                if player.swordNum <= 0 || tmpself!.sword == nil {
                    return
                }
                player.countDownSword()
                if tmpself!.sword.attack < 4 {
                    bgNode.runAction(magicSound)
                }
                
                let scaleAction = SKAction.scaleBy(1.1, duration: 1.0)
                //剣の攻撃力を上げる
                tmpself!.sword.attack++
                for oSword: SMSwordNode in tmpself!.optionSwords {
                    oSword.attack++
                    if oSword.attack == 2 {
                        oSword.circle.color = UIColor.blueColor()
                        oSword.circle.colorBlendFactor = 0.5
                        
                        //剣にパーティクルを付ける
                        SMNodeUtil.makeParticleNode(CGPoint(x:0,y:80), filename: "tameParticle.sks", hide: false, node: oSword)
                    }
                    oSword.runAction(scaleAction)
                }
                
                if tmpself!.sword.attack == 2 {
                    tmpself!.sword.circle.color = UIColor.blueColor()
                    tmpself!.sword.circle.colorBlendFactor = 0.5
                    
                    //剣にパーティクルを付ける
                    SMNodeUtil.makeParticleNode(CGPoint(x:0,y:80), filename: "tameParticle.sks", hide: false, node: tmpself!.sword)
                }
                tmpself!.sword.runAction(scaleAction)
                
                //剣を作成する
                let optrandtype = randomSwordType()
                var positionx = tmpself!.sword.position.x
                var appendx: Int = 50 + 50 * ((tmpself!.optionSwords.count)/2)
                if (tmpself!.optionSwords.count+1) % 2 == 0 {
                    appendx = appendx * -1
                }
                positionx = positionx + CGFloat(appendx)
                let position = CGPoint(x: positionx, y: tmpself!.sword.position.y - 20)
                let optsword = swordFactory.create(optrandtype, position: position, startPoint: tmpself!.touchStartPoint)
                optsword!.makeSword()
                tmpself!.optionSwords.append(optsword!)
            })
            let repeatSwordAction = SKAction.repeatActionForever(SKAction.sequence([waitAction,custumAction]))
            sword.runAction(repeatSwordAction)
            
            //マルチタッチには対応しない
            break
        }
    }
    
    //スワイプした時に呼び出される
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチが開始されていないのなら即リターン
        if touchStartPoint == nil {
            return
        }
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            sword.swipeSword(location)
            for optsword: SMSwordNode in optionSwords {
                optsword.swipeSword(location)
            }
            //マルチタッチには対応しない
            break
        }
    }
    
    //タッチして指を離したときに呼び出される
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチが開始されていないのなら即リターン
        if touchStartPoint == nil {
            return
        }
        for touch: AnyObject in touches {
            //let location = touch.locationInNode(self)
            bgNode.runAction(fadeSound)
            switch sword.type {
            case .EXCALIBUR:
                bgNode.runAction(kuraeSound)
                bgNode.runAction(kuraeSound)
                bgNode.runAction(kuraeSound)
            case .KATANA:
                bgNode.runAction(sokodaSound)
                bgNode.runAction(sokodaSound)
                bgNode.runAction(sokodaSound)
            case .PANZERSTECHER:
                bgNode.runAction(yaaSound)
                bgNode.runAction(yaaSound)
                bgNode.runAction(yaaSound)
            case .ZWEIHANDER:
                bgNode.runAction(eiSound)
                bgNode.runAction(eiSound)
                bgNode.runAction(eiSound)
            default:
                break;
            }
            //剣を発射する
            bgNode.runAction(sword.shotSound)
            sword.shotSword()
            for optsword: SMSwordNode in optionSwords {
                optsword.shotSword()
            }
            sword = nil
            optionSwords.removeAll()
            touchStartPoint = nil
            
            //マルチタッチには対応しない
            break
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
        
        hitSound = nil
        sasaruSound = nil
        swordSound = nil
        nagarebosiSound = nil
        explodeSound = nil
        explodeSound2 = nil
        magicSound = nil
        kiruSound = nil
        kuraeSound = nil
        konoSound = nil
        sokodaSound = nil
        toryaSound = nil
        eiSound = nil
        yaaSound = nil
        powerupSound = nil
        itemgetSound = nil
        comboSound = nil
        hawawaSound = nil
        mataSound = nil
        koredeSound = nil
        kakinSound = nil
        fadeSound = nil
        choroiSound = nil
        
        //タイトル画面表示
        let scene = GameTitleScene()
        
        // Configure the view.
        let skView = self.view! 
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        skView.presentScene(scene)
        //scene.runAction(mataSound)
        //scene.runAction(mataSound)
        //scene.runAction(mataSound)
        
        stageManager.resetStage()
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
        let guardType = ColliderType.Guard
        let guardType2 = ColliderType.Guard2
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
            } else if contact.bodyA.categoryBitMask & guardType == guardType ||
                contact.bodyB.categoryBitMask & guardType == guardType {
                if contact.bodyA.categoryBitMask & guardType == guardType {
                    let `guard`: SMGuardNode = contact.bodyA.node as! SMGuardNode
                    let sword: SMSwordNode = contact.bodyB.node as! SMSwordNode
                    `guard`.hitSword(sword)
                } else if contact.bodyB.categoryBitMask & guardType == guardType {
                    let `guard`: SMGuardNode = contact.bodyB.node as! SMGuardNode
                    let sword: SMSwordNode = contact.bodyA.node as! SMSwordNode
                    `guard`.hitSword(sword)
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
        } else if contact.bodyA.categoryBitMask & guardType2 == guardType2 ||
            contact.bodyB.categoryBitMask & guardType2 == guardType2 {
            //自機バリアとの衝突
            if contact.bodyA.categoryBitMask & enegyType == enegyType ||
                contact.bodyB.categoryBitMask & enegyType == enegyType {
                var guard2: SMGuardNode2!
                var enegy: SMEnegyNode!
                if contact.bodyA.categoryBitMask & enegyType == enegyType {
                    enegy = contact.bodyA.node as! SMEnegyNode
                    guard2 = contact.bodyB.node as! SMGuardNode2
                } else if contact.bodyB.categoryBitMask & enegyType == enegyType {
                    enegy = contact.bodyB.node as! SMEnegyNode
                    guard2 = contact.bodyA.node as! SMGuardNode2
                }
                    guard2.hitEnegy(enegy)
            }
        }
    }
    
    //ゲームオーバーの処理
    func gameover() {
        //self.runAction(hawawaSound)
        //self.runAction(hawawaSound)
        //self.runAction(hawawaSound)
        stageManager.currentStage.audioPlayer?.stop()
        
        //フラグをtrueにする
        gameoverflg = true
        
        //敵の停止
        enemysNode.speed = 0.0
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:0.0)
        
        //SNSボタンの表示
        twButton.position = CGPoint(x: self.frame.width * 0.45, y: self.frame.size.height * 0.25)
        twButton.name = "twitter_button"
        twButton.zPosition = 100
        self.addChild(twButton)
        
        fbButton.position = CGPoint(x: self.frame.width * 0.65, y: self.frame.size.height * 0.25)
        fbButton.name = "facebook_button"
        fbButton.zPosition = 100
        self.addChild(fbButton)
        
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
