//
//  GameShopScene.swift
//  proton
//
//  Created by KakimotoMasaaki on 2016/01/11.
//  Copyright © 2016年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit

// ショップ画面
class GameShopScene: SKScene {
    var vc: GameViewController? = nil
    let buyLabel1 = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    let BUY_LABEL1_NAME = "buyLabel1"
    
    //画面の初期化処理
    override func didMoveToView(view: SKView) {
        vc!.shopDelegate = self
        let ud = NSUserDefaults.standardUserDefaults()
        var bgNode :SKNode = SKNode()
        self.addChild(bgNode)
        
        //ショップタイトル
        var titleLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
        titleLabel.name = "titleLabel"
        titleLabel.text = "ゆうすけのよろずやへようこそ！"
        titleLabel.fontSize = 20
        titleLabel.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        titleLabel.zPosition = 1000
        self.addChild(titleLabel)
        titleLabel.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.height-80)
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .CurrencyStyle
        for product in vc!.products {
            let prodID = product.productIdentifier
            //剣＋２
            if(prodID == vc!.productID1) {
                
                //剣+2(剣の初期保持数が+2)
                nf.locale = product.priceLocale
                let itemLabel1 = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
                itemLabel1.name = "itemLabel1"
                itemLabel1.text = "・\(product.localizedTitle)(\(product.localizedDescription))"
                itemLabel1.fontSize = 16
                itemLabel1.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
                itemLabel1.zPosition = 1000
                self.addChild(itemLabel1)
                itemLabel1.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.height-150)
                
                buyLabel1.name = BUY_LABEL1_NAME
                let price1 = nf.stringFromNumber(product.price)!
                buyLabel1.text = "購入する( \(price1) )"
                buyLabel1.fontSize = 16
                buyLabel1.fontColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.9)
                buyLabel1.zPosition = 1000
                self.addChild(buyLabel1)
                buyLabel1.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.height-170)
                //購入済みの場合テキストや色を変える
                let buyflg1 = ud.integerForKey(GameViewController.ADD_SWORDS_PLUS2_UDKEY)
                if buyflg1 != 0 {
                    //購入済
                    buyLabel1.text = "購入済"
                    buyLabel1.name = BUY_LABEL1_NAME + "complete"
                    buyLabel1.fontColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
                }
            }
        }
        
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
                } else if tmpnode.name == BUY_LABEL1_NAME {
                    addSwordsButtonTapped()
                }
            }
        }
    }
    func addSwordsButtonTapped() {
        print("addSwordsButtonTapped")
        for product in vc!.products {
            var prodID = product.productIdentifier
            if(prodID == vc!.productID1) {
                buyLabel1.text = "購入処理中"
                buyLabel1.color = UIColor.whiteColor()
                buyLabel1.name = BUY_LABEL1_NAME + "proc"
                vc!.buyAddSwords(product as! SKProduct)
                break
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