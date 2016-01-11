//
//  GameShopScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2016/01/11.
//  Copyright © 2016年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

// ショップ画面
class GameShopScene: SKScene {
    var vc: GameViewController? = nil
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        var bgNode :SKNode = SKNode()
        self.addChild(bgNode)
        
        //ショップタイトル
        var titleLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        titleLabel.name = "titleLabel"
        titleLabel.text = "ショップ"
        titleLabel.fontSize = 20
        titleLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        titleLabel.zPosition = 1000
        self.addChild(titleLabel)
        titleLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.height-80)
        
        // タイトルに戻るボタン作成
        var returnLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        returnLabel.name = "returnLabel"
        returnLabel.text = "タイトルに戻る"
        returnLabel.fontSize = 20
        returnLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        returnLabel.zPosition = 1000
        self.addChild(returnLabel)
        returnLabel.position = CGPoint(x: (self.frame.size.width/2), y: 50)
        
        //背景パーティクル
        let particle = SKEmitterNode(fileNamed: "titleParticle.sks")
        particle!.zPosition = -10
        particle!.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bgNode.addChild(particle!)
    }
    
    //タッチした時に呼び出される
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let touchPoint = touch.locationInNode(self)
            let node: SKNode! =  self.nodeAtPoint(touchPoint)
            if let tmpnode = node {
                if tmpnode.name == "returnLabel" {
                    returnTitle()
                }
            }
        }
    }
    //タイトル画面に戻る
    func returnTitle() {
        //タイトル画面表示
        let scene = GameTitleScene()
        scene.vc = self.vc
        
        // Configure the view.
        let skView = self.view! 
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        skView.presentScene(scene)
        
        //全ての子ノードを破棄
        self.removeAllChildren()
    }
}