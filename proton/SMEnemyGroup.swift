//
//  SMEnemyGroup.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//敵の集団管理クラス
class SMEnemyGroup: SMEnemyDelegate {
    var enemys: [SMEnemyNode]!
    var type: EnemyGroupType!
    weak var delegate: SMStage? //次の敵出現の通知用
    var killcount: Int = 0
    var interval = 10.0
    
    init(enemys: [SMEnemyNode], type: EnemyGroupType) {
        self.enemys = enemys
        self.type = type
        for enemy in enemys {
            enemy.delegate = self
        }
    }
    
    //敵の集団を作成
    func makeEnemyGroup() {
        for enemy in enemys {
            enemy.makeEnemy()
        }
        if self.type == EnemyGroupType.INTERVAL {
            weak var tmpself = self
            let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
                //指定秒後に次のグループへ
                for enemy in tmpself!.enemys {
                    SMNodeUtil.fadeRemoveNode(enemy)
                }
                tmpself!.enemys.removeAll() //配列から全削除
                tmpself!.delegate?.nextEnemyGroupDelegate()
            })
            let waitAction = SKAction.waitForDuration(interval)
            enemysNode.runAction(SKAction.sequence([waitAction,custumAction]))
        }
    }
    
    //敵が死んだときに呼び出される
    func enemyDeadDelegate(enemy: SMEnemyNode) {
        killcount++
        if killcount >= enemys.count {
            enemy.scene!.runAction(choroiSound)
            enemy.scene!.runAction(choroiSound)
            enemy.scene!.runAction(choroiSound)
        }
        if (type == EnemyGroupType.ALLDEAD
            && killcount >= enemys.count) {
            
            enemys.removeAll() //配列から全削除
            //次の敵グループへ
            delegate?.nextEnemyGroupDelegate()
        }
    }
    //デイニシャライザ
    deinit {
        println("enemygroup deinit")
    }
}