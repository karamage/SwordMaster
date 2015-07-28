//
//  SMItemFactory.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/22.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMItemFactory {
    let coinTexture: SKTexture = SKTexture(imageNamed: "coin")
    let daiyaTexture: SKTexture = SKTexture(imageNamed: "daiya")
    let swordnumTexture: SKTexture = SKTexture(imageNamed: "sword_icon2")
    func createRandom(location:CGPoint) -> SMItemNode? {
        var rand = arc4random_uniform(100)
        var ret: SMItemNode?
        if rand % 10 == 1 {
            ret = create(ItemType.DAIYA, location: location)
        } else if rand % 10 == 2 {
            ret = create(ItemType.SWORDNUMUP, location: location)
        } else {
            ret = create(ItemType.COIN, location: location)
        }
        return ret
    }
    func create(type:ItemType, location:CGPoint) -> SMItemNode? {
        var ret:SMItemNode?
        switch type {
        case ItemType.COIN:
            ret = SMItemNode(texture: coinTexture, type: ItemType.COIN, location: location, parentnode: enemysNode)
            break
        case ItemType.DAIYA:
            ret = SMItemNode(texture: daiyaTexture, type: ItemType.DAIYA, location: location, parentnode: enemysNode)
            break
        case ItemType.SWORDNUMUP:
            ret = SMItemNode(texture: swordnumTexture, type: ItemType.SWORDNUMUP, location: location, parentnode: enemysNode)
            break
        default:
            break
        }
        return ret
    }
}
