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
            stage = makeStage1()
            break
        case 2:
            stage = makeStage2()
            break
        case 3:
            stage = makeStage3()
            break
        case 4:
            stage = makeStage4()
            break
        default:
            break
        }
        return stage
    }
    func makeStage1() -> SMStage{
        var enemyGroups: [SMEnemyGroup]!
        var enemyGroup0: SMEnemyGroup!
        var enemyArray0: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup: SMEnemyGroup!
        var enemyArray: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup1: SMEnemyGroup!
        var enemyArray1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup2: SMEnemyGroup!
        var enemyArray2: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup3: SMEnemyGroup!
        var enemyArray3: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4: SMEnemyGroup!
        var enemyArray4: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4_1: SMEnemyGroup!
        var enemyArray4_1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup5: SMEnemyGroup!
        var enemyArray5: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup6: SMEnemyGroup!
        var enemyArray6: [SMEnemyNode] = [SMEnemyNode]()
        var bossGroup: SMEnemyGroup!
        var bossArray: [SMEnemyNode] = [SMEnemyNode]()
        
        //最初、敵CUBEが3匹
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray.append(enemy!)
        }
        /*
        let enemy = enemyFactory.create(EnemyType.KNIGHT)
        //let enemy = enemyFactory.create(EnemyType.LION)
        let enemy = enemyFactory.create(EnemyType.AKNIGHT)
        enemyArray.append(enemy!)
*/
        //全滅させるまで次に進めない
        enemyGroup = SMEnemyGroup(enemys:enemyArray, type:EnemyGroupType.INTERVAL)
        //enemyGroup.interval = 20.0
        
        //最初、敵CUBEが3匹
        for i in 0..<4 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray1.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup1 = SMEnemyGroup(enemys:enemyArray1, type:EnemyGroupType.INTERVAL)
        
        //次５匹
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray2.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup2 = SMEnemyGroup(enemys:enemyArray2, type:EnemyGroupType.INTERVAL)
        
        //次8匹
        for i in 0..<8 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray3.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup3 = SMEnemyGroup(enemys:enemyArray3, type:EnemyGroupType.INTERVAL)
        
        //次の敵、2匹
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray4.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4 = SMEnemyGroup(enemys:enemyArray4, type:EnemyGroupType.INTERVAL)
        
        //次の敵、３匹
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray4_1.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4_1 = SMEnemyGroup(enemys:enemyArray4_1, type:EnemyGroupType.INTERVAL)
        
        //次の敵
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray5.append(enemy!)
        }
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray5.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup5 = SMEnemyGroup(enemys:enemyArray5, type:EnemyGroupType.INTERVAL)
        enemyGroup5.interval = 13.0
        
        //次の敵
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray6.append(enemy!)
        }
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray6.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup6 = SMEnemyGroup(enemys:enemyArray6, type:EnemyGroupType.INTERVAL)
        enemyGroup6.interval = 15.0
        
        for i in 0..<20 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray0.append(enemy!)
        }
        enemyGroup0 = SMEnemyGroup(enemys:enemyArray0, type:EnemyGroupType.INTERVAL)
        
        enemyGroups = [enemyGroup,enemyGroup1,enemyGroup2,enemyGroup3,enemyGroup4,enemyGroup4_1,enemyGroup5,enemyGroup6,enemyGroup0]
        if debugflg {
            enemyGroups = [enemyGroup]
        }
        
        //ボス作成
        let boss1: SMEnemyNode? = enemyFactory.create(EnemyType.BOSS1)
        boss1?.isBoss = true
        bossArray.append(boss1!)
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            bossArray.append(enemy!)
        }
        bossGroup = SMEnemyGroup(enemys:bossArray, type:EnemyGroupType.BOSS)
        
        //ステージ1作成
        let stage = SMStage(background: stage1Background, bgSound: "bgm_maoudamashii_neorock33", enemyGroups: enemyGroups, bossEnemyGroup: bossGroup, bossSound: "bosssound1", bgParticle:"scrollParticle.sks")
        return stage
    }
    
    func makeStage2() -> SMStage {
        var enemyGroups: [SMEnemyGroup]!
        var enemyGroup0: SMEnemyGroup!
        var enemyArray0: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup: SMEnemyGroup!
        var enemyArray: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup1: SMEnemyGroup!
        var enemyArray1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup2: SMEnemyGroup!
        var enemyArray2: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup3: SMEnemyGroup!
        var enemyArray3: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4: SMEnemyGroup!
        var enemyArray4: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4_1: SMEnemyGroup!
        var enemyArray4_1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup5: SMEnemyGroup!
        var enemyArray5: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup6: SMEnemyGroup!
        var enemyArray6: [SMEnemyNode] = [SMEnemyNode]()
        var bossGroup: SMEnemyGroup!
        var bossArray: [SMEnemyNode] = [SMEnemyNode]()
        
        //最初、敵CUBEが20匹
        for i in 0..<20 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray0.append(enemy!)
        }
        enemyGroup0 = SMEnemyGroup(enemys:enemyArray0, type:EnemyGroupType.INTERVAL)
        
        //最初、敵CUBEが5匹
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray.append(enemy!)
        }
        
        //全滅させるまで次に進めない
        enemyGroup = SMEnemyGroup(enemys:enemyArray, type:EnemyGroupType.INTERVAL)
        
        
        //最初、敵CUBEが3匹
        for i in 0..<8 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray1.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup1 = SMEnemyGroup(enemys:enemyArray1, type:EnemyGroupType.INTERVAL)
        
        //次５匹
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray2.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup2 = SMEnemyGroup(enemys:enemyArray2, type:EnemyGroupType.INTERVAL)
        
        //次8匹
        for i in 0..<8 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray3.append(enemy!)
        }
        //全滅させるまで次に進めない
        enemyGroup3 = SMEnemyGroup(enemys:enemyArray3, type:EnemyGroupType.INTERVAL)
        enemyGroup3.interval = 15.0
        
        //次の敵、2匹
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.KNIGHT)
            enemyArray4.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4 = SMEnemyGroup(enemys:enemyArray4, type:EnemyGroupType.INTERVAL)
        enemyGroup4.interval = 15.0
        
        //次の敵、３匹
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray4_1.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4_1 = SMEnemyGroup(enemys:enemyArray4_1, type:EnemyGroupType.ALLDEAD)
        
        //次の敵
        for i in 0..<1 {
            let enemy = enemyFactory.create(EnemyType.AKNIGHT)
            enemyArray5.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup5 = SMEnemyGroup(enemys:enemyArray5, type:EnemyGroupType.ALLDEAD)
        
        //次の敵
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.KNIGHT)
            enemyArray6.append(enemy!)
        }
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray6.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup6 = SMEnemyGroup(enemys:enemyArray6, type:EnemyGroupType.INTERVAL)
        enemyGroup6.interval = 20.0
        
        enemyGroups = [enemyGroup0,enemyGroup,enemyGroup1,enemyGroup2,enemyGroup3,enemyGroup4,enemyGroup4_1,enemyGroup5,enemyGroup6]
        
        if debugflg {
            enemyGroups = [enemyGroup]
        }
        //ボス作成
        let boss1: SMEnemyNode? = enemyFactory.create(EnemyType.BOSS2)
        boss1?.isBoss = true
        bossArray.append(boss1!)
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.LION)
            bossArray.append(enemy!)
        }
        bossGroup = SMEnemyGroup(enemys:bossArray, type:EnemyGroupType.BOSS)
        
        //ステージ2作成
        let stage = SMStage(background: stage2Background, bgSound: "bgm_stage2", enemyGroups: enemyGroups, bossEnemyGroup: bossGroup, bossSound: "bosssound1", bgParticle:"scrollParticle2.sks")
        return stage
    }
    
    func makeStage3() -> SMStage {
        var enemyGroups: [SMEnemyGroup]!
        var enemyGroup0: SMEnemyGroup!
        var enemyArray0: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup: SMEnemyGroup!
        var enemyArray: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup1: SMEnemyGroup!
        var enemyArray1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup2: SMEnemyGroup!
        var enemyArray2: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup3: SMEnemyGroup!
        var enemyArray3: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4: SMEnemyGroup!
        var enemyArray4: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup4_1: SMEnemyGroup!
        var enemyArray4_1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup5: SMEnemyGroup!
        var enemyArray5: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup6: SMEnemyGroup!
        var enemyArray6: [SMEnemyNode] = [SMEnemyNode]()
        var bossGroup: SMEnemyGroup!
        var bossArray: [SMEnemyNode] = [SMEnemyNode]()
        
        for i in 0..<20 {
            let enemy = enemyFactory.create(EnemyType.CUBE)
            enemyArray0.append(enemy!)
        }
        enemyGroup0 = SMEnemyGroup(enemys:enemyArray0, type:EnemyGroupType.INTERVAL)
        
        //最初、敵CUBEが5匹
        for i in 0..<10 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray.append(enemy!)
        }
        enemyGroup = SMEnemyGroup(enemys:enemyArray, type:EnemyGroupType.INTERVAL)
        enemyGroup.interval = 13.0
        
        //ライオン
        for i in 0..<5 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray1.append(enemy!)
        }
        enemyGroup1 = SMEnemyGroup(enemys:enemyArray1, type:EnemyGroupType.ALLDEAD)
        enemyGroup1.interval = 13.0
        
        //次５匹
        for i in 0..<8 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray2.append(enemy!)
        }
        enemyGroup2 = SMEnemyGroup(enemys:enemyArray2, type:EnemyGroupType.INTERVAL)
        enemyGroup2.interval = 13.0
        
        //次8匹
        for i in 0..<15 {
            let enemy = enemyFactory.create(EnemyType.FLY)
            enemyArray3.append(enemy!)
        }
        enemyGroup3 = SMEnemyGroup(enemys:enemyArray3, type:EnemyGroupType.INTERVAL)
        enemyGroup3.interval = 15.0
        
        //次の敵、2匹
        for i in 0..<6 {
            let enemy = enemyFactory.create(EnemyType.KNIGHT)
            enemyArray4.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4 = SMEnemyGroup(enemys:enemyArray4, type:EnemyGroupType.INTERVAL)
        enemyGroup4.interval = 15.0
        
        //次の敵、３匹
        for i in 0..<6 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray4_1.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup4_1 = SMEnemyGroup(enemys:enemyArray4_1, type:EnemyGroupType.ALLDEAD)
        enemyGroup4_1.interval = 20.0
        
        //次の敵
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.AKNIGHT)
            enemyArray5.append(enemy!)
        }
        for i in 0..<3 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray5.append(enemy!)
        }
        enemyGroup5 = SMEnemyGroup(enemys:enemyArray5, type:EnemyGroupType.ALLDEAD)
        enemyGroup5.interval = 20.0
        
        //次の敵
        for i in 0..<8 {
            let enemy = enemyFactory.create(EnemyType.KNIGHT)
            enemyArray6.append(enemy!)
        }
        for i in 0..<10 {
            let enemy = enemyFactory.create(EnemyType.CUBE2)
            enemyArray6.append(enemy!)
        }
        //時間が経つと次に進む
        enemyGroup6 = SMEnemyGroup(enemys:enemyArray6, type:EnemyGroupType.INTERVAL)
        enemyGroup6.interval = 20.0
        
        enemyGroups = [enemyGroup0,enemyGroup,enemyGroup1,enemyGroup2,enemyGroup3,enemyGroup4,enemyGroup4_1,enemyGroup5,enemyGroup6]
        
        if debugflg {
            enemyGroups = [enemyGroup]
        }
        
        //ボス作成
        let boss1: SMEnemyNode? = enemyFactory.create(EnemyType.BOSS3)
        boss1?.isBoss = true
        bossArray.append(boss1!)
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.AKNIGHT)
            bossArray.append(enemy!)
        }
        bossGroup = SMEnemyGroup(enemys:bossArray, type:EnemyGroupType.BOSS)
        
        //ステージ3作成
        let stage = SMStage(background: stage3Background, bgSound: "bgm_stage3", enemyGroups: enemyGroups, bossEnemyGroup: bossGroup, bossSound: "stage3boss", bgParticle:"scrollParticle.sks")
        return stage
    }
    
    func makeStage4() -> SMStage {
        var enemyGroups: [SMEnemyGroup]!
        var enemyGroup1: SMEnemyGroup!
        var enemyArray1: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup2: SMEnemyGroup!
        var enemyArray2: [SMEnemyNode] = [SMEnemyNode]()
        var enemyGroup3: SMEnemyGroup!
        var enemyArray3: [SMEnemyNode] = [SMEnemyNode]()
        var bossGroup: SMEnemyGroup!
        var bossArray: [SMEnemyNode] = [SMEnemyNode]()
        
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray1.append(enemy!)
        }
        var bosst = enemyFactory.create(EnemyType.BOSS1)
        enemyArray1.append(bosst!)
        enemyGroup1 = SMEnemyGroup(enemys:enemyArray1, type:EnemyGroupType.ALLDEAD)
        
        for i in 0..<4 {
            let enemy = enemyFactory.create(EnemyType.LION)
            enemyArray2.append(enemy!)
        }
        bosst = enemyFactory.create(EnemyType.BOSS2)
        enemyArray2.append(bosst!)
        enemyGroup2 = SMEnemyGroup(enemys:enemyArray2, type:EnemyGroupType.ALLDEAD)
        
        for i in 0..<4 {
            let enemy = enemyFactory.create(EnemyType.AKNIGHT)
            enemyArray3.append(enemy!)
        }
        bosst = enemyFactory.create(EnemyType.BOSS3)
        enemyArray3.append(bosst!)
        enemyGroup3 = SMEnemyGroup(enemys:enemyArray3, type:EnemyGroupType.ALLDEAD)
        
        
        enemyGroups = [enemyGroup1,enemyGroup2,enemyGroup3]
        
        if debugflg {
            //enemyGroups = [enemyGroup1]
        }
        
        //ボス作成
        let boss1: SMEnemyNode? = enemyFactory.create(EnemyType.BOSS4)
        boss1?.isBoss = true
        bossArray.append(boss1!)
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.AKNIGHT)
            bossArray.append(enemy!)
        }
        for i in 0..<2 {
            let enemy = enemyFactory.create(EnemyType.LION)
            bossArray.append(enemy!)
        }
        bossGroup = SMEnemyGroup(enemys:bossArray, type:EnemyGroupType.BOSS)
        
        //ステージ4作成
        let stage = SMStage(background: stage4Background, bgSound: "stage4", enemyGroups: enemyGroups, bossEnemyGroup: bossGroup, bossSound: "stage4boss", bgParticle:"scrollParticle4.sks")
        return stage
    }
}