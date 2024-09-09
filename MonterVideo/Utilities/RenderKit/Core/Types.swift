//
//  Types.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import simd
import Metal

protocol Sizeable { }
extension Sizeable {
    static var size: Int {
        return MemoryLayout<Self>.size
    }

    static var stride: Int {
        return MemoryLayout<Self>.stride
    }

    static func size(_ count: Int) -> Int {
        return MemoryLayout<Self>.size * count
    }

    static func stride(_ count: Int) -> Int {
        return MemoryLayout<Self>.stride * count
    }
}

//
extension Float: Sizeable { }
extension SIMD2<Float>: Sizeable { }
extension SIMD3<Float>: Sizeable { }
extension SIMD4<Float>: Sizeable { }

struct TextureVertex {
    var position: simd_float2
    var texCoord: simd_float2
}
