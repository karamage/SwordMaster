//
//  SMStageFactory.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//ステージのファクトリークラス
class SMStageFactory {
    func create(stageNumber: Int) -> SMStage? {
        var stage:SMStage? = nil
        switch stageNumber {
        case 1:
            var enemyGroups: [SMEnemyGroup]!
            var enemyGroup: SMEnemyGroup!
            var enemyArray: [SMEnemyNode] = [SMEnemyNode]()
            var enemyGroup2: SMEnemyGroup!
            var enemyArray2: [SMEnemyNode] = [SMEnemyNode]()
            var enemyGroup3: SMEnemyGroup!
            var enemyArray3: [SMEnemyNode] = [SMEnemyNode]()
            var enemyGroup4: SMEnemyGroup!
            var enemyArray4: [SMEnemyNode] = [SMEnemyNode]()
            var enemyGroup5: SMEnemyGroup!
            var enemyArray5: [SMEnemyNode] = [SMEnemyNode]()
            var bossGroup: SMEnemyGroup!
            var bossArray: [SMEnemyNode] = [SMEnemyNode]()
            
            //最初、敵CUBEが3匹
            for i in 0..<3 {
                let enemy = enemyFactory.create(EnemyType.CUBE)
                enemyArray.append(enemy!)
            }
            //全滅させるまで次に進めない
            enemyGroup = SMEnemyGroup(enemys:enemyArray, type:EnemyGroupType.INTERVAL)
            
            //次５匹
            for i in 0..<5 {
                let enemy = enemyFactory.create(EnemyType.CUBE)
                enemyArray2.append(enemy!)
            }
            //全滅させるまで次に進めない
            enemyGroup2 = SMEnemyGroup(enemys:enemyArray2, type:EnemyGroupType.INTERVAL)
            
            //次10匹
            for i in 0..<10 {
                let enemy = enemyFactory.create(EnemyType.CUBE)
                enemyArray3.append(enemy!)
            }
            //全滅させるまで次に進めない
            enemyGroup3 = SMEnemyGroup(enemys:enemyArray3, type:EnemyGroupType.INTERVAL)
            
            //次の敵、３匹
            for i in 0..<3 {
                let enemy = enemyFactory.create(EnemyType.FLY)
                enemyArray4.append(enemy!)
            }
            //時間が経つと次に進む
            enemyGroup4 = SMEnemyGroup(enemys:enemyArray4, type:EnemyGroupType.INTERVAL)
            
            //次の敵
            for i in 0..<5 {
                let enemy = enemyFactory.create(EnemyType.FLY)
                enemyArray5.append(enemy!)
            }
            for i in 0..<10 {
                let enemy = enemyFactory.create(EnemyType.CUBE)
                enemyArray5.append(enemy!)
            }
            
            //時間が経つと次に進む
            enemyGroup5 = SMEnemyGroup(enemys:enemyArray5, type:EnemyGroupType.INTERVAL)
            enemyGroup5.interval = 13.0
            
            enemyGroups = [enemyGroup,enemyGroup2,enemyGroup3,enemyGroup4,enemyGroup5]
            //enemyGroups = [enemyGroup]
            
            //ボス作成
            var boss1: SMEnemyNode? = enemyFactory.create(EnemyType.BOSS1)
            bossArray.append(boss1!)
            bossGroup = SMEnemyGroup(enemys:bossArray, type:EnemyGroupType.BOSS)
            
            //ステージ1作成
            stage = SMStage(background: stage1Background, bgSound: "sound", enemyGroups: enemyGroups, bossEnemyGroup: bossGroup, bossSound: "bosssound1")
            break
        default:
            break
        }
        return stage
    }
}