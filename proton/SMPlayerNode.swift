//
//  SMPlayer.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//自機ノード管理クラス
class SMPlayerNode: SKSpriteNode {
    //装備している剣の種類
    var swordType: SwordType = SwordType.EXCALIBUR
    //剣の最大値
    var swordMaxNum: Int = 3
    //剣の残りの弾
    var swordNum: Int = 3
    //剣のアイコンの配列
    var swordIcons: [SKSpriteNode] = [SKSpriteNode]()
    
    //被弾できるヒットポイント
    var hitpoint: Int = 1
    
    //アニメーション用ノード
    var hane: SKSpriteNode!
    var warp: SKSpriteNode!
    var dead: SKSpriteNode!
    var haneAim: [SKTexture]!
    var haneAim1: [SKTexture]!
    var haneAim2: [SKTexture]!
    var warpAim: [SKTexture]!
    var warpAim2: [SKTexture]!
    
    //アイテムを取得した時の処理
    func contactItem(item: SMItemNode) {
        item.physicsBody?.categoryBitMask = ColliderType.None
        switch item.type {
        case .COIN:
            totalScore += 10
            scoreLabel.text = "\(totalScore)"
        default:
            break
        }
        item.removeFromParent()
        SMNodeUtil.makeParticleNode(CGPoint(x: self.position.x, y: self.position.y + 30), filename: "MyParticle.sks", node: bgNode)
    }
    
    //相手の弾を被弾したときの処理
    func damegedEnegy(enegy: SMEnegyNode) {
        enegy.physicsBody?.categoryBitMask = ColliderType.None
        hitpoint--
        SMNodeUtil.fadeRemoveNode(enegy)
    }
    
    //プレイヤーが死んだ時の処理
    func deadPlayer() {
        //やられた効果音再生
        self.runAction(explodeSound)
        
        //やられたアニメーション作成
        SMNodeUtil.makeParticleNode(self.position, filename: "deadParticle.sks", hide: true, node: bgNode)
        
        //プレイヤー削除
        SMNodeUtil.fadeRemoveNode(self)
    }
    
    //プレイヤー作成
    func makePlayer(node: SKNode, textures: [SKTexture]) {
        self.blendMode = SKBlendMode.Add
        self.alpha = 0.9
        self.position = CGPoint(x: node.frame.size.width * 0.5, y: 0)
        //self.colorBlendFactor = 1.0
        //self.color = SKColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        //物理シミュレーション設定
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.Player
        //self.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Enegy
        self.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Enegy
        
        node.addChild(self)
        self.zPosition = 2
        
        //パラパラアニメーション
        let paraAction = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
        let repeatParaAction = SKAction.repeatActionForever(paraAction)
        self.runAction(repeatParaAction)
        
        //画面下から登場
        var playerAction = SKAction.moveToY(50, duration: 2)
        var repeatAction = SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(45, duration: 2),SKAction.moveToY(55, duration: 2)]))
        self.runAction(SKAction.sequence([playerAction, repeatAction]))
        
        var scaleAction1 = SKAction.scaleTo(1.1, duration: 2)
        var scaleAction2 = SKAction.scaleTo(1.0, duration: 2)
        var scaleAction3 = SKAction.scaleTo(0.9, duration: 2)
        var scaleRepeat = SKAction.repeatActionForever(SKAction.sequence([scaleAction1,scaleAction2,scaleAction3]))
        self.runAction(scaleRepeat)
        
        //パーティクル作成
        let particlePosition = CGPoint(x: 0, y: 25)
        SMNodeUtil.makeParticleNode(particlePosition, filename:"playerParticle.sks", hide:false, node:self)
        
        //アニメーション作成
        makePlayerAnimation()
        
        //剣のアイコンを作成
        makeSwordIcon()
    }
    
    //剣のアイコンを作成
    func makeSwordIcon() {
        for i in 0..<swordMaxNum {
            makeSwordIcon(i)
        }
    }
    func makeSwordIcon(index: Int) {
        let icon = SKSpriteNode(texture: swordIconTexture)
        let width:CGFloat! = icon.texture?.size().width
        icon.position = CGPoint(x: width * CGFloat(index), y:CGFloat(0.0))
        swordIcons.append(icon)
        statusNode.addChild(icon)
    }
    
    //剣をカウントダウン
    func countDownSword() {
        swordNum--
        swordIcons[swordNum].removeFromParent()
        swordIcons.removeAtIndex(swordNum)
    }
    
    //剣をカウントアップ
    func countUpSword() {
        makeSwordIcon(swordNum)
        swordNum++
    }
    
    //プレイヤーのアニメーションを作成する
    func makePlayerAnimation() {
        //羽のアニメーションを切り出す
        haneAim = SMAnimationUtil.explodeAnime("wing", xFrame: 5, yFrame: 6)
        haneAim1 = [SKTexture](haneAim[3...6])
        haneAim2 = [SKTexture](haneAim[7...22])
        //ワープのアニメーションを切り出す
        warpAim = SMAnimationUtil.explodeAnime("warp", xFrame: 2, yFrame: 13)
        warpAim2 = [SKTexture](warpAim[0...14])
        
        //羽のアニメーションを作成
        hane = SKSpriteNode(texture: haneAim[0], size: haneAim[0].size())
        hane.blendMode = SKBlendMode.Add
        hane.alpha = 0.9
        self.addChild(hane!)
        //hane.position = CGPoint(x: self.frame.size.width/2, y: 50)
        
        var haneAnimAction = SKAction.animateWithTextures(haneAim, timePerFrame: 0.1, resize:false, restore:true)
        var haneAnimAction1 = SKAction.animateWithTextures(haneAim1, timePerFrame: 0.1, resize:false, restore:true)
        var haneAnimAction2 = SKAction.animateWithTextures(haneAim2, timePerFrame: 0.1, resize:false, restore:true)
        var scaleHaneAction = SKAction.scaleTo(0.5, duration: 0.5)
        var repeatHaneAction = SKAction.repeatActionForever(haneAnimAction2)
        hane.runAction(SKAction.sequence([haneAnimAction,haneAnimAction1,scaleHaneAction, repeatHaneAction]))
        
        //ワープのアニメーションを作成
        warp = SKSpriteNode(texture: warpAim[0], size: warpAim[0].size())
        warp.blendMode = SKBlendMode.Add
        warp.alpha = 0.8
        self.addChild(warp!)
        //warp.position = CGPoint(x: self.frame.size.width/2, y: 50)
        var warpAnimAction = SKAction.animateWithTextures(warpAim2, timePerFrame: 0.1, resize:false, restore:true)
        var warpRemoveAction = SKAction.removeFromParent()
        warp.runAction(SKAction.sequence([warpAnimAction,warpRemoveAction]))
    }
}