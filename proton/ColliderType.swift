//
//  ColliderType.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/10.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import Foundation

//当たり判定用
struct ColliderType {
    static let Player: UInt32 = (1<<0)
    static let Enemy: UInt32 = (1<<1)
    static let Sword: UInt32 = (1<<2)
    static let Item: UInt32 = (1<<3)
    static let Wall: UInt32 = (1<<4)
    static let Enegy: UInt32 = (1<<5)
    static let Guard: UInt32 = (1<<6)
    static let Guard2: UInt32 = (1<<7)
    static let None: UInt32 = (1<<9)
}