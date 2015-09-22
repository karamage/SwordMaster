//
//  SMAnimationUtil.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation
import SpriteKit

//アニメーションUtilクラス
class SMAnimationUtil {
    //一枚の画像からアニメーションを切り出す
    class func explodeAnime(imageName: String, xFrame: UInt, yFrame: UInt) -> [SKTexture] {
        
        var ret: [SKTexture] = []
        let image = UIImage(named: imageName)
        
        let inner: CGImageRef! = image?.CGImage
        
        let xFrameInt: Int = Int(xFrame)
        let yFrameInt: Int = Int(yFrame)
        
        //var width: Int = Int(image?.size.width) / xFrameInt
        var width:Int = 0
        var height:Int = 0
        var scale: CGFloat = 0
        if let tmpimage = image {
            width = Int(tmpimage.size.width) / xFrameInt
            height = Int(tmpimage.size.height) / yFrameInt
            scale = tmpimage.scale
        }
        
        var fx: CGFloat = 0
        var fy: CGFloat = 0
        var fwidth: CGFloat = 0
        var fheight: CGFloat = 0
        for i in 0..<yFrameInt {
            for i2 in 0..<xFrameInt {
                fx = 0+(CGFloat(i2 * width) * scale)
                fy = 0+(CGFloat(i * height) * scale)
                fwidth = CGFloat(width)*scale
                fheight = CGFloat(height)*scale
                let rect: CGRect = CGRectMake(fx, fy, fwidth, fheight)
                let ref: CGImage? = CGImageCreateWithImageInRect(inner, rect)
                //var rev: UIImage? = UIImage(CGImage: ref)
                let texture = SKTexture(CGImage: ref!)
                ret.append(texture)
            }
        }
        
        return ret
    }
}