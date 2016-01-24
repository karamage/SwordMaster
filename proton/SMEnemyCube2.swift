//
//  SMEnemyCube2.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/08/05.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit

class SMEnemyCube2: SMEnemyCube {
    override init(texture: SKTexture) {
        super.init(texture: texture)
        self.hitpoint = 2
        self.diffence = 0
        self.score = 20
        self.color = UIColor.redColor()
        self.colorBlendFactor = 0.2
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.density = 10.0
        makeEnegy(1)
    }
}