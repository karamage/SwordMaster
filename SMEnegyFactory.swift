//
//  SMEnegyFactory.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/16.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMEnegyFactory {
    let enegyTexture = SKTexture(imageNamed: "enegy")
    func create(position: CGPoint) -> SMEnegyNode {
        let enegy = SMEnegyNode(texture: enegyTexture, location: position, parentnode: enemysNode)
        return enegy
    }
}
