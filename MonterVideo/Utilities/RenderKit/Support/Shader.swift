//
//  ShaderClient.swift
//  MonterVideo
//
//  Created by 김동현 on 9/6/24.
//

import MetalKit

//struct ShaderClient {
//    struct Function {
//        enum Types {
//            case Texture
//        }
//
//        var name: String
//        var functionName: String
//        var function: MTLFunction
//    }
//
//    var library: MTLLibrary
//
//    init(library: MTLLibrary) {
//        self.library = library
//    }
//}

enum Shader {
    case texture(library: MTLLibrary)
    
    enum State {
        case vertex
        case fragment
    }
    
    enum Name: String {
        case vertexFunction
        case fragmentFunction
    }
        
    var vertexFunction: MTLFunction? {
        switch self {
        case .texture(let library):
            return library.makeFunction(name: Name.vertexFunction.rawValue)
        }
    }
    
    var fragmentFunction: MTLFunction? {
        switch self {
        case .texture(let library):
            return library.makeFunction(name: Name.fragmentFunction.rawValue)
        }
    }
}
