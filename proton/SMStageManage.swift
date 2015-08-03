//
//  SMStageManage.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//ステージ管理
class SMStageManage {
    //var stages: [SMStage]!
    var currentStage: SMStage!
    var currentStageNum: Int = 1
    
    //何周したかどうか
    var clearNum: Int = 0
    
    init() {
    }
    
    //ステージの作成
    func makeStage() {
        //ステージ情報のインスタンスを作成
        currentStage = stageFactory.create(currentStageNum)
        
        if let stage = currentStage {
            stage.makeStage()
        }
    }
    
    //次のステージに進める
    func nextStage() {
        //currentStage = nil
        currentStageNum++
    }
    
    //最初のステージに戻る
    func resetStage() {
        currentStage = nil
        currentStageNum = 1
    }
}