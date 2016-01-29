//
//  SMStage.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

//, AVAudioPlayerDelegate
//ステージ情報
class SMStage: SMEnemyGroupDelegate {
    //音楽プレイヤー
    var audioPlayer:AVAudioPlayer?
    //背景
    var background: SKSpriteNode!
    //背景音楽
    var bgSound: String!
    //敵グループの配列
    var enemyGroups: [SMEnemyGroup]!
    var currentEnemyGroupNum: Int = 0
    
    //ボス
    //var boss: SMEnemyNode!
    //ボスと同時に出現する雑魚敵
    var bossEnemyGroup: SMEnemyGroup!
    
    //ボス音楽
    var bossSound: String!
    
    var bgParticle: String!
    
    init(background: SKSpriteNode, bgSound: String, enemyGroups: [SMEnemyGroup]?,  bossEnemyGroup: SMEnemyGroup?, bossSound: String?, bgParticle: String) {
        self.background = background
        self.bgSound = bgSound
        self.enemyGroups = enemyGroups
        //self.boss = boss
        self.bossEnemyGroup = bossEnemyGroup
        self.bossSound = bossSound
        self.bgParticle = bgParticle
        //通知用
        for enemyGroup in enemyGroups! {
            enemyGroup.delegate = self
        }
        bossEnemyGroup?.delegate = self
    }
    
    //ステージの作成
    func makeStage() {
        bgNode.removeAllChildren()
        
        //背景を描画
        let bg = background
        bg.position = CGPoint(x:0, y:0)
        bg.texture?.filteringMode = SKTextureFilteringMode.Nearest
        bg.anchorPoint = CGPoint(x:0.5, y:0) //中央に合わせる
        bg.zPosition = -100
        bg.alpha = 0.0
        bgNode.addChild(bg)
        let fadein = SKAction.fadeInWithDuration(2.0)
        bg.runAction(fadein)
        
        makeBgParticle(bgParticle)
        
        //背景を徐々に下にスクロールする
        let bgScrollAction = SKAction.moveToY(-60.0, duration: 10) //指定座標まで移動
        let bgScrollRevAction = SKAction.moveToY(0, duration: 10)
        let bgScroll = SKAction.repeatActionForever(SKAction.sequence([bgScrollAction,bgScrollRevAction]))
        bg.runAction(bgScroll)
        let scaleAction1 = SKAction.scaleTo(0.97, duration: 2)
        let scaleAction2 = SKAction.scaleTo(1.0, duration: 2)
        let scaleAction3 = SKAction.scaleTo(1.03, duration: 2)
        let scaleRepeat = SKAction.repeatActionForever(SKAction.sequence([scaleAction1,scaleAction2,scaleAction3]))
        bg.runAction(scaleRepeat)
        
        //敵の集団を作成
        makeEnemyGroup()
        
        startBgm(self.bgSound)
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
    
    //背景用パーティクル作成
    func makeBgParticle(file:String = "scrollParticle.sks") {
        let particle = SKEmitterNode(fileNamed: file)
        particle!.zPosition = 0.0
        bgNode.addChild(particle!)
        
        if file == "scrollParticle4.sks" {
            particle!.position = CGPoint(x: CGFloat(frameWidth / 2), y: CGFloat(frameHeight / 2 + 100))
        } else {
            if file == "scrollParticle.sks" {
                let particle2 = SKEmitterNode(fileNamed: "scrollParticle1_2.sks")
                particle2!.zPosition = 0.0
                bgNode.addChild(particle2!)
                particle2!.position = CGPoint(x: CGFloat(frameWidth / 2), y: CGFloat(frameHeight))
            }
            particle!.position = CGPoint(x: CGFloat(frameWidth / 2), y: CGFloat(frameHeight))
        }
    }
    //敵を作成
    func makeEnemyGroup() {
        enemyGroups[currentEnemyGroupNum].makeEnemyGroup()
    }
    
    //次の敵へ
    func nextEnemyGroup() {
        currentEnemyGroupNum++
    }
    
    func nextEnemyGroupDelegate() {
        nextEnemyGroup()
        if currentEnemyGroupNum < enemyGroups.count {
            makeEnemyGroup()
        } else {
            //ボスへ
            makeBoss()
        }
    }
    
    func makeBoss() {
        //BGM一旦停止
        audioPlayer!.stop()
        startBgm(bossSound)
        bossEnemyGroup.makeEnemyGroup()
    }
    
    //次のステージへ
    func nextStageDelegate() {
        //println("nextStageDelegate")
        //BGM一旦停止
        audioPlayer!.stop()
        
        weak var tmpself = self
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            //今のステージの後始末
            tmpself!.destroyStage()
            
            if stageManager.currentStageNum == 4 {
                //全4ステージ
                stageManager.clearNum++
                stageManager.currentStageNum = 0
            }
            
            //次のステージの開始
            stageManager.nextStage()
            stageManager.makeStage()
            player.playerStart([playerTexture,playerTexture2])
            player.makeHaneAnim()
            player.makeWarpAnim()
        })
        let wait = SKAction.waitForDuration(10.0)
        bgNode.runAction(SKAction.sequence([wait, custumAction]))
        let fadeout = SKAction.fadeOutWithDuration(10.0)
        background.runAction(fadeout)
    }
    
    func destroyStage() {
        enemyGroups.removeAll()
    }
    
}