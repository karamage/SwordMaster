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
    var swordTexture5 = SKTexture(imageNamed: "balmung")
    var swordTexture6 = SKTexture(imageNamed: "darknessedge")
    var swordTexture7 = SKTexture(imageNamed: "falchion")
    var swordTexture8 = SKTexture(imageNamed: "gladius")
    var swordTexture9 = SKTexture(imageNamed: "halberd")
    var swordTexture10 = SKTexture(imageNamed: "rapier")
    var shotSound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
    
    func create(type:SwordType, position: CGPoint, startPoint: CGPoint) -> SMSwordNode? {
        var sword:SMSwordNode? = nil
        switch type {
        case .EXCALIBUR:
            sword = SMSwordNode(texture:swordTexture1, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .KATANA:
            sword = SMSwordNode(texture:swordTexture2, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .PANZERSTECHER:
            sword = SMSwordNode(texture:swordTexture3, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .ZWEIHANDER:
            sword = SMSwordNode(texture:swordTexture4, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .BALMUNG:
            sword = SMSwordNode(texture:swordTexture5, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .DARKNESSEDGE:
            sword = SMSwordNode(texture:swordTexture6, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .FALCION:
            sword = SMSwordNode(texture:swordTexture7, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .GLADIUS:
            sword = SMSwordNode(texture:swordTexture8, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .HALBERD:
            sword = SMSwordNode(texture:swordTexture9, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        case .RAPIER:
            sword = SMSwordNode(texture:swordTexture10, type: type, shotSound:shotSound, location:position, parentnode:swordsNode, startPoint:startPoint)
            break
        default:
            break
        }
        return sword
    }
}