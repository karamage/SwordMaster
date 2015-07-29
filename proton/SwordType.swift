//
//  SwordType.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation

//剣の種類
enum SwordType: Int {
    case EXCALIBUR = 0
    case KATANA
    case ZWEIHANDER
    case PANZERSTECHER
}

func randomSwordType() -> SwordType {
    var rand = arc4random_uniform(100)
    rand = rand % 4
    switch rand {
    case 0:
        return SwordType.EXCALIBUR
    case 1:
        return SwordType.KATANA
    case 2:
        return SwordType.ZWEIHANDER
    case 3:
        return SwordType.PANZERSTECHER
    default:
        return SwordType.EXCALIBUR
    }
}