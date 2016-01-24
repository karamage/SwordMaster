//
//  SMEnemyCubeBlack.swift
//  proton
//
//  Created by KakimotoMasaaki on 2016/01/24.
//  Copyright © 2016年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit

class SMEnemyCubeBlack: SMEnemyCube {
    override init(texture: SKTexture) {
        super.init(texture: texture)
        self.hitpoint = 3
        self.diffence = 10
        self.score = 1000
        self.color = UIColor.blackColor()
        self.colorBlendFactor = 0.7
        self.itemnum = 10
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.density = 200.0
        self.physicsBody?.restitution = 0
    }
}