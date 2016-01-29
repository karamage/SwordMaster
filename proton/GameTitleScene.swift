//
//  GameTitleScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/16.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import iAd

class GameTitleScene: SKScene {
    var vc: GameViewController? = nil
    //音楽プレイヤー
    var audioPlayer:AVAudioPlayer?
    //テクスチャ
    var titleTexture = SKTexture(imageNamed: "title")
    var logoTexture = SKTexture(imageNamed: "logo")
    var logoTexture2 = SKTexture(imageNamed: "logo2")
    var startTexture = SKTexture(imageNamed: "start")
    var bgNode :SKNode = SKNode()
    var hiScoreLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    //オープニング曲
    //var openingSound = SKAction.playSoundFileNamed("short_song_minami_kirakira.mp3", waitForCompletion: false)
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        
        //音楽再生
        //self.runAction(openingSound)
        startBgm("short_song_minami_kirakira")
        
        //背景管理用ノード
        bgNode.position = CGPoint(x:0, y:0)
        self.addChild(bgNode)
        bgNode.zPosition = -100
        
        //背景
        let title = SKSpriteNode(texture: titleTexture, size: titleTexture.size())
        title.position = CGPoint(x:self.frame.width/2, y:0)
        title.anchorPoint = CGPoint(x:0.5, y:0) //中央に合わせる
        title.zPosition = 1
        bgNode.addChild(title)
        
        let scaleAction = SKAction.scaleBy(1.2, duration: 0.8)
        title.runAction(scaleAction)
        let fadeinAction = SKAction.fadeInWithDuration(0.5)
        title.runAction(fadeinAction)
        
        //NSUserDefaultsのインスタンスを生成
        let defaults = NSUserDefaults.standardUserDefaults()
        //前回の保存内容があるかどうかを判定
        if((defaults.objectForKey("hiScore")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            hiScore = defaults.objectForKey("hiScore") as! Int
        }
        
        hiScoreLabel.text = "High Score: \(hiScore)"
        hiScoreLabel.fontSize = 25
        hiScoreLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        hiScoreLabel.zPosition = 1000
        self.addChild(hiScoreLabel)
        hiScoreLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.size.height - 100)
        
        //ロゴ
        var logoSize: CGSize = logoTexture.size()
        let gain = self.view!.frame.width / logoSize.width
        logoSize.width *= gain
        logoSize.height *= gain
        let logo = SKSpriteNode(texture: logoTexture, size: logoSize)
        // TODO: -20はそもそも画像が寄っているため。画像を直すのが正しい。
        logo.position = CGPoint(x: self.frame.width / 2 - 10, y: self.frame.height - 90)
        logo.zPosition = 100
        logo.alpha = 0.0
        logo.color = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 0.8)
        logo.colorBlendFactor = 0.7
        logo.blendMode =  SKBlendMode.Add
        let fadeinAction2 = SKAction.fadeInWithDuration(2.0)
        bgNode.addChild(logo)
        logo.runAction(fadeinAction2)
        
        //ロゴ2
        logoSize = logoTexture2.size()
        logoSize.width *= gain
        logoSize.height *= gain
        let logo2 = SKSpriteNode(texture: logoTexture2, size: logoSize)
        logo2.position = CGPoint(x: self.frame.width / 2 + 10, y: self.frame.height - 180)
        logo2.zPosition = 110
        logo2.alpha = 0.0
        logo2.color = UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 0.8)
        logo2.colorBlendFactor = 0.7
        logo2.blendMode =  SKBlendMode.Add
        let fadeinAction3 = SKAction.fadeInWithDuration(3.5)
        bgNode.addChild(logo2)
        logo2.runAction(fadeinAction3)
        
        //スタートボタン
        let start = SKSpriteNode(imageNamed: "start", normalMapped: true)
        start.name = "start"
        start.position = CGPoint(x: self.frame.width/2, y:60)
        start.zPosition = 120
        start.alpha = 0.9
        bgNode.addChild(start)
        let fadeoutAction = SKAction.fadeOutWithDuration(0.5)
        let waitAction = SKAction.waitForDuration(0.5)
        start.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeinAction,waitAction, fadeoutAction])))
        
        //ショップボタン
        let cart = SKSpriteNode(imageNamed: "cart", normalMapped: true)
        cart.name = "cart"
        cart.position = CGPoint(x: 90, y:140)
        cart.zPosition = 130
        cart.alpha = 0.9
        bgNode.addChild(cart)
        cart.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeinAction,waitAction, fadeoutAction])))
        
        //ショップパーティクル
        let particlet = SKEmitterNode(fileNamed: "shopButton.sks")
        particlet!.zPosition = -10
        particlet!.position = CGPoint(x: -10, y: -20)
        cart.addChild(particlet!)
        
        /*
        let shopLabel = SKLabelNode()
        shopLabel.text = "Shop"
        shopLabel.fontSize = 12
        shopLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        shopLabel.zPosition = 1000
        cart.addChild(shopLabel)
        shopLabel.position = CGPoint(x: 30, y: 30)
        */
        
        //背景パーティクル
        let particle = SKEmitterNode(fileNamed: "titleParticle.sks")
        particle!.zPosition = -10
        particle!.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bgNode.addChild(particle!)
        
        //剣をクルクルまわす
        var swordTextures = [swordFactory.swordTexture1, swordFactory.swordTexture2, swordFactory.swordTexture3, swordFactory.swordTexture4, swordFactory.swordTexture5, swordFactory.swordTexture6, swordFactory.swordTexture7, swordFactory.swordTexture8, swordFactory.swordTexture9, swordFactory.swordTexture10]
        var sword1: SKSpriteNode? = nil
        //円を描く
        var path =  CGPathCreateMutable()
        CGPathAddArc(path, nil, CGFloat(0), CGFloat(0), CGFloat(150.0), CGFloat(0), CGFloat(M_PI * 2), true)
        CGPathCloseSubpath(path)
        let circleAction = SKAction.followPath(path, asOffset: true, orientToPath: false, duration: 3)
        let resetMoveAction = SKAction.moveTo(CGPoint(x:self.frame.width/2,y:self.frame.height/2), duration: 0)
        let repeatAction = SKAction.repeatActionForever(SKAction.sequence([  circleAction,resetMoveAction]))
        var swordi = 0
        
        for swordTexture in swordTextures {
            var sword = SKSpriteNode(texture: swordTexture)
            if sword1 == nil {
                sword1 = sword
            }
            sword.position = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
            sword.zPosition = 10
            bgNode.addChild(sword)
            
            let waitAction2 = SKAction.waitForDuration(0.30 * Double(swordi))
            sword.runAction(SKAction.sequence([waitAction2, repeatAction]))
            swordi++
        }
        
        //光の演出(iOS8以上のみ)
        if #available(iOS 8.0, *) {
            let light:SKLightNode = SKLightNode()
            light.categoryBitMask = 1
            light.falloff = 1
            light.ambientColor = UIColor.whiteColor()
            light.lightColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 0.9)
            light.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
            sword1!.addChild(light)
            
            start.shadowedBitMask = 1
            start.shadowCastBitMask = 1
            start.lightingBitMask = 1
            cart.shadowedBitMask = 1
            cart.shadowCastBitMask = 1
            cart.lightingBitMask = 1
        } else {
            // Fallback on earlier versions
        }
        
        //歌付き音楽を流す
        
        // iAd(バナー)の自動表示
        //self.vc!.canDisplayBannerAds = true
        
    }
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchPoint = touch.locationInNode(self)
            let node: SKNode! =  self.nodeAtPoint(touchPoint)
            if let tmpnode = node {
                if tmpnode.name == "start" {
                    //ゲーム開始
                    audioPlayer!.stop()
                    gamestart()
                    return
                } else if tmpnode.name == "cart" {
                    if vc!.isShopEnabled {
                        // ショップの画面を開く
                        audioPlayer!.stop()
                        showshop()
                        return
                    }
                }
            }
        }
    }
    func startBgm(filename: String) {
        // 再生する audio ファイルのパスを取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")!)
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        //audioPlayer!.delegate = self
        audioPlayer?.numberOfLoops = -1
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    //ゲームスタート
    func gamestart() {
        
        //ゲーム画面表示
        let scene = GameScene()
        scene.vc = self.vc
        
        // Configure the view.
        let skView = self.view! 
        if debugflg {
            skView.showsFPS = true
            skView.showsNodeCount = true
        } else {
            skView.showsFPS = false
            skView.showsNodeCount = false
        }
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        let transition = SKTransition.crossFadeWithDuration(2)
        skView.presentScene(scene, transition:transition)
        
        //スタートの効果音流す
        
        // iAd(バナー)の非表示
        //self.vc!.canDisplayBannerAds = false
        self.vc!.adbanner.hidden = true
    }
    //店画面を表示する
    func showshop() {
        //ゲーム画面表示
        let scene = GameShopScene()
        scene.vc = self.vc
        
        // Configure the view.
        let skView = self.view!
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        //let transition = SKTransition.crossFadeWithDuration(2)
        let transition = SKTransition.fadeWithDuration(1)
        skView.presentScene(scene, transition:transition)
    }
}