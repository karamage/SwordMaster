//
//  GameTitleScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/16.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class GameTitleScene: SKScene {
    //テクスチャ
    var titleTexture = SKTexture(imageNamed: "title")
    var logoTexture = SKTexture(imageNamed: "logo")
    var logoTexture2 = SKTexture(imageNamed: "logo2")
    var startTexture = SKTexture(imageNamed: "start")
    var bgNode :SKNode = SKNode()
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
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
        
        let scaleAction = SKAction.scaleBy(1.2, duration: 0.3)
        title.runAction(scaleAction)
        let fadeinAction = SKAction.fadeInWithDuration(0.5)
        title.runAction(fadeinAction)
        
        
        //ロゴ
        let logo = SKSpriteNode(texture: logoTexture, size: logoTexture.size())
        logo.position = CGPoint(x: self.frame.width/2 - 20, y: self.frame.height - 90)
        logo.zPosition = 100
        bgNode.addChild(logo)
        
        //ロゴ2
        let logo2 = SKSpriteNode(texture: logoTexture2, size: logoTexture2.size())
        logo2.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 180)
        logo2.zPosition = 110
        bgNode.addChild(logo2)
        
        //スタートボタン
        let start = SKSpriteNode(texture: startTexture, size: startTexture.size())
        start.position = CGPoint(x: self.frame.width/2, y:60)
        start.zPosition = 120
        start.alpha = 0.8
        bgNode.addChild(start)
        let fadeoutAction = SKAction.fadeOutWithDuration(0.5)
        let waitAction = SKAction.waitForDuration(0.5)
        start.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeinAction,waitAction, fadeoutAction])))
        
        //背景パーティクル
        let particle = SKEmitterNode(fileNamed: "titleParticle.sks")
        particle.zPosition = -10
        particle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bgNode.addChild(particle)
        
        //剣をクルクルまわす
        var swordTexture = swordFactory.swordTexture1
        var sword1 = SKSpriteNode(texture: swordTexture)
        sword1.position = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
        sword1.zPosition = 10
        bgNode.addChild(sword1)
        //円を描く
        var path =  CGPathCreateMutable()
        CGPathAddArc(path, nil, CGFloat(0), CGFloat(0), CGFloat(150.0), CGFloat(0), CGFloat(M_PI * 2), true)
        CGPathCloseSubpath(path)
        let circleAction = SKAction.followPath(path, asOffset: true, orientToPath: false, duration: 3)
        let resetMoveAction = SKAction.moveTo(CGPoint(x:self.frame.width/2,y:self.frame.height/2), duration: 0)
        sword1.runAction(SKAction.repeatActionForever(SKAction.sequence([ circleAction,resetMoveAction])))
        
        //歌付き音楽を流す
    }
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //ゲーム画面表示
        let scene = GameScene()
        
        // Configure the view.
        let skView = self.view! as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        let transition = SKTransition.crossFadeWithDuration(2)
        skView.presentScene(scene, transition:transition)
        
        //スタートの効果音流す
    }
}