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
            var enemyGroup: SMEnemyGroup!
            var enemyGroups: [SMEnemyGroup]!
            var enemyArray: [SMEnemyNode] = [SMEnemyNode]()
            
            for i in 0..<5 {
                let enemy = enemyFactory.create(EnemyType.CUBE)
                enemyArray.append(enemy!)
            }
            enemyGroup = SMEnemyGroup(enemys:enemyArray)
            enemyGroups = [enemyGroup]
            //ステージ1作成
            stage = SMStage(background: stage1Background, bgSound: stage1BgSound, enemyGroups: enemyGroups, boss: nil, bossEnemyGroups: nil, bossSound: nil)
            break
        default:
            break
        }
        return stage
    }
}