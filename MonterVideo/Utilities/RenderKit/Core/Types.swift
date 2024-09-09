//
//  Types.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import simd
import Metal

protocol sizeable{ }
extension sizeable{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int)->Int{
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int)->Int{
        return MemoryLayout<Self>.stride * count
    }
}
//
extension Float: sizeable { }
extension float2: sizeable { }
extension float3: sizeable { }
extension float4: sizeable { }
//
//struct Vertex: sizeable{
//    var position: float4
//    var color: float4
//}
//
//
//struct ModelConstants: sizeable{
//    var modelMatrix = matrix_identity_float4x4
//}


struct TextureVertex {
    var position: simd_float2
    var texCoord: simd_float2
}

//public enum Semantic {
//    case texture
//}
//
//enum PipelineState {
//    case vertex
//    case fragment
//}

// enum ShaderFucntion {
//     enum Name {
//         static let vertex = "vertexFunction"
//         static let fragment = "fragmentFunction"
//     }
//
//    func name(_ semantic: Semantic, state: functionState) -> String {
//        switch (semantic, state) {
//        case (.texture, .vertex): return Name.vertex
//        case (.texture, .fragment): return Name.fragment
//        }
//    }
//}

//enum Rendering {
//    enum Semantic {
//        case basic
//        case texture
//    }
//}
//
//enum ShaderFucntion {
//    case vertex(Semantic)
//    case fragment(Semantic)
//    
//    enum Name: String {
//        case vertexFunction
//        case fragmentFunction
//    }
//    
//    var name: String {
//        switch self {
//        case .vertex, .basic:
//            
//        }
//    }
//    
//}
