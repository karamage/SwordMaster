//
//  SMSwordNode.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

class SMSwordNode: SKSpriteNode {
    //剣の種類
    var type: SwordType
    var shotSound: SKAction
    var startPoint: CGPoint
    weak var parentnode: SKNode!
    var circle: SKSpriteNode
    var swipex: Int = 0
    var isShot: Bool = false
    
    //攻撃力
    var attack: Int = 1
    //耐久力
    var hitpoint: Int = 1
    
    init(texture: SKTexture, type: SwordType, shotSound:SKAction, location: CGPoint,parentnode:SKNode, startPoint: CGPoint){
        self.type = type
        self.shotSound = shotSound
        self.startPoint = startPoint
        self.parentnode = parentnode
        //self.circle = SKShapeNode(circleOfRadius: 15)
        self.circle = SKSpriteNode(imageNamed: "magic_circle")
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        super.init(texture: texture, color:color, size:texture.size())
        self.position = CGPoint(x:location.x, y:location.y - 40)
    }
    required override init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //剣の作成
    func makeSword(){
        //let waitSoundAction = SKAction.waitForDuration(0.5)
        //let magic = SKAction.sequence([waitSoundAction, magicSound])
        //self.runAction(magic)
        //self.runAction(magic)
        //self.runAction(magic)
        
        //物理シミュレーション設定
        /*
        if #available(iOS 8.0, *) {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        } else {
            // Fallback on earlier versions
        }*/
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 15, height: 65))
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 2.0
        
        self.physicsBody?.categoryBitMask = ColliderType.Sword
        self.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Sword | ColliderType.Enegy | ColliderType.Guard
        self.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Sword  | ColliderType.Enegy | ColliderType.Guard
        
        self.alpha = 0.0
        self.anchorPoint = CGPoint(x:0.5,y:0)
        
        parentnode.addChild(self)
        
        // 円を描画.
        makeCircle(self.position)
        
        //透明度を徐々に上げて登場
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        self.runAction(fadeInAction)
        
        //少し前に移動
        let frontMoveAction = SKAction.moveToY(self.startPoint.y + 10, duration: 0.5)
        self.runAction(SKAction.sequence([frontMoveAction]))
        
    }
    
    //魔法陣を作成する
    func makeCircle(position:CGPoint) {
        // ShapeNodeの座標を指定.
        circle.position = position
        circle.blendMode = SKBlendMode.Add
        circle.alpha = 0.0
        
        // ShapeNodeの塗りつぶしの色を指定.
        //Circle.fillColor = UIColor.redColor()
        
        let scaleZeroAction = SKAction.scaleTo(0, duration: 0)
        let scaleAction = SKAction.scaleXTo(0.4, y: 0.4, duration: 0.5)
        circle.runAction(SKAction.sequence([scaleZeroAction,scaleAction]))
        
        // sceneにShapeNodeを追加.
        parentnode.addChild(circle)
        
        let fadeIn = SKAction.fadeAlphaTo(0.8, duration: 1.0)
        circle.runAction(fadeIn)
        
        
        //回転のアニメーション
        let rotateAction = SKAction.rotateByAngle(CGFloat(360*M_PI/180), duration: 10)
        circle.runAction(rotateAction)
    }
    
    //剣をスワイプする
    func swipeSword(swipepoint: CGPoint) {
        //println("swipepoint:\(swipepoint)")
        let x:Int = Int(swipepoint.x) - Int(startPoint.x)
        swipex = x * -1
        let angle: CGFloat = CGFloat(x) / CGFloat(180.0) * CGFloat(M_PI) ;
        //回転のアニメーション
        //var rotateAction = SKAction.rotateByAngle(1, duration: 0)
        let rotateAction = SKAction.rotateToAngle(angle, duration: 0)
        self.runAction(SKAction.sequence([rotateAction]))
    }
    
    //剣の発射
    func shotSword() {
        self.removeAllActions()
        self.alpha = 1.0
        self.anchorPoint = CGPoint(x:0.5,y:0.5)
        self.physicsBody?.dynamic = true
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx:CGFloat(swipex), dy:70.0 + (10.0 * CGFloat(self.attack))))
        self.isShot = true
        
        if self.attack >= 3 {
            self.physicsBody?.restitution = 0
            self.physicsBody?.density = 3.0
        }
        
        //2秒後に消す
        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.waitForDuration(2.00)
        let custumAction = SKAction.customActionWithDuration(0.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
            if player.swordNum < player.swordMaxNum {
                player.countUpSword()
            }
        })
        let sequenceAction = SKAction.sequence([durationAction,custumAction,removeAction])
        self.runAction(sequenceAction)
        
        let fadeAction = SKAction.fadeAlphaTo(0, duration: 2.0)
        self.runAction(fadeAction)
        
        removeCircle()
        
        //パーティクル作成
        let point = CGPoint(x:0, y:30)
        SMNodeUtil.makeMagicParticle(startPoint, node: parentnode)
        SMNodeUtil.makeSparkParticle(point, node: self)
    }
    
    func removeCircle() {
        SMNodeUtil.fadeRemoveNode(circle)
    }
    
    //デイニシャライザ
    deinit {
        //println("sword deinit")
    }
}
