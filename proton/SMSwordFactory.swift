//
//  SMSwordFactory.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/13.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//剣のファクトリークラス
class SMSwordFactory {
    func create(type:SwordType) -> SMSwordNode? {
        let sword:SMSwordNode? = nil
        switch type {
        case .EXCALIBUR:
            break
        default:
            break
        }
        return sword
    }
}