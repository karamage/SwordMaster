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
    func createRandom(location:CGPoint) -> SMItemNode? {
        var rand = arc4random_uniform(100)
        var ret = create(ItemType.COIN, location: location)
        return ret
    }
    func create(type:ItemType, location:CGPoint) -> SMItemNode? {
        var ret:SMItemNode?
        switch type {
        case ItemType.COIN:
            ret = SMItemNode(texture: coinTexture, type: ItemType.COIN, location: location, parentnode: enemysNode)
            break
        default:
            break
        }
        return ret
    }
}
