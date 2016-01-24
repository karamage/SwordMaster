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
    let speedTexture: SKTexture = SKTexture(imageNamed: "speed")
    let shieldTexture: SKTexture = SKTexture(imageNamed: "shield")
    let heartTexture: SKTexture = SKTexture(imageNamed: "heart")
    func createRandom(location:CGPoint) -> SMItemNode? {
        let rand = arc4random_uniform(100)
        var ret: SMItemNode?
        if rand % 10 == 1 {
            ret = create(ItemType.DAIYA, location: location)
        } else if rand % 20 == 2 {
            ret = create(ItemType.SWORDNUMUP, location: location)
        } else if rand % 10 == 3 {
            ret = create(ItemType.SPEEDUP, location: location)
        } else if rand % 15 == 4 {
            ret = create(ItemType.SHIELD, location: location)
        } else if rand % 40 == 5 {
            ret = create(ItemType.HEART, location: location)
        } else if rand % 40 == 6 {
            ret = create(ItemType.SWORDPOWERUP, location: location)
        } else if rand % 40 == 7 {
            ret = create(ItemType.SWORDCHARGEUP, location: location)
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
        case ItemType.DAIYA:
            ret = SMItemNode(texture: daiyaTexture, type: ItemType.DAIYA, location: location, parentnode: enemysNode)
        case ItemType.SWORDNUMUP, ItemType.SWORDPOWERUP, ItemType.SWORDCHARGEUP:
            ret = SMItemNode(texture: swordnumTexture, type: ItemType.SWORDNUMUP, location: location, parentnode: enemysNode)
        case ItemType.SPEEDUP:
            ret = SMItemNode(texture: speedTexture, type: ItemType.SPEEDUP, location: location, parentnode: enemysNode)
        case ItemType.SHIELD:
            ret = SMItemNode(texture: shieldTexture, type: ItemType.SHIELD, location: location, parentnode: enemysNode)
        case ItemType.HEART:
            ret = SMItemNode(texture: heartTexture, type: ItemType.HEART, location: location, parentnode: enemysNode)
        default:
            break
        }
        return ret
    }
}
