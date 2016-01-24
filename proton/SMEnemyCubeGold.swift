//
//  SMEnemyCubeGold.swift
//  proton
//
//  Created by KakimotoMasaaki on 2016/01/24.
//  Copyright © 2016年 Masaaki Kakimoto. All rights reserved.
//

import SpriteKit

class SMEnemyCubeGold: SMEnemyCube {
    override init(texture: SKTexture) {
        super.init(texture: texture)
        self.hitpoint = 3
        self.diffence = 0
        self.score = 1000
        self.color = UIColor.yellowColor()
        self.colorBlendFactor = 0.9
        self.itemnum = 10
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeEnemy() {
        super.makeEnemy()
        self.physicsBody?.density = 10.0
        let randY = arc4random_uniform(100)
        
        //プレイヤーに迫って移動してくるようにする
        var vector = SMNodeUtil.makePlayerVector(self.position, player: player)
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx:(vector.dx + CGFloat(randY))/30, dy:vector.dy/30))
    }
}