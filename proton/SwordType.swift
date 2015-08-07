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
    case BALMUNG
    case DARKNESSEDGE
    case FALCION
    case GLADIUS
    case HALBERD
    case RAPIER
}

func randomSwordType() -> SwordType {
    var rand = arc4random_uniform(100)
    rand = rand % 10
    switch rand {
    case 0:
        return SwordType.EXCALIBUR
    case 1:
        return SwordType.KATANA
    case 2:
        return SwordType.ZWEIHANDER
    case 3:
        return SwordType.PANZERSTECHER
    case 4:
        return SwordType.BALMUNG
    case 5:
        return SwordType.DARKNESSEDGE
    case 6:
        return SwordType.FALCION
    case 7:
        return SwordType.GLADIUS
    case 8:
        return SwordType.HALBERD
    case 9:
        return SwordType.RAPIER
    default:
        return SwordType.EXCALIBUR
    }
}