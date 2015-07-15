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
    //剣のテクスチャ
    var swordTexture1 = SKTexture(imageNamed: "swordex")
    var swordTexture2 = SKTexture(imageNamed: "katana")
    var swordTexture3 = SKTexture(imageNamed: "panzerstecher")
    var swordTexture4 = SKTexture(imageNamed: "zweihander")
    var shotSound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
    
    func create(type:SwordType, position: CGPoint) -> SMSwordNode? {
        var sword:SMSwordNode? = nil
        switch type {
        case .EXCALIBUR:
            sword = SMSwordNode(texture:swordTexture1, type: type, shotSound:shotSound, location:position, parentnode:swordsNode)
            break
        case .KATANA:
            sword = SMSwordNode(texture:swordTexture2, type: type, shotSound:shotSound, location:position, parentnode:swordsNode)
            break
        case .PANZERSTECHER:
            sword = SMSwordNode(texture:swordTexture3, type: type, shotSound:shotSound, location:position, parentnode:swordsNode)
            break
        case .ZWEIHANDER:
            sword = SMSwordNode(texture:swordTexture4, type: type, shotSound:shotSound, location:position, parentnode:swordsNode)
            break
        default:
            break
        }
        return sword
    }
}