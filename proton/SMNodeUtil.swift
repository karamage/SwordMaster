//
//  SMParticleNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//パーティクルを管理するクラス
class SMNodeUtil {
    class func makeParticleNode(position:CGPoint?, filename: String, hide: Bool = true, node: SKNode) {
        var particle = SKEmitterNode(fileNamed: filename)
        node.addChild(particle)
        
        if let tmp = position {
            particle.position = tmp
        }
        
        //消さないんだったらリターン
        if !hide {
            return
        }
        fadeRemoveNode(particle)
    }
    
    
    //一秒後にフェードしながらノードを消す
    class func fadeRemoveNode(removenode: SKNode!) {
        //１秒後に消す
        var removeAction = SKAction.removeFromParent()
        var durationAction = SKAction.waitForDuration(1.50)
        var sequenceAction = SKAction.sequence([durationAction,removeAction])
        removenode.runAction(sequenceAction)
        
        removenode.alpha = 1
        
        var fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
        removenode.runAction(fadeAction)
    }
}