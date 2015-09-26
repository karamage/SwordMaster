//
//  EnemyGroupType.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/14.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation

enum EnemyGroupType {
    //敵を全滅させるまで次に進めない
    case ALLDEAD
    //一定時間立つまで次に進まない
    case INTERVAL
    //ボス
    case BOSS
}