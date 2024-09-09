//
//  Shader.swift
//  MonterVideo
//
//  Created by 김동현 on 9/6/24.
//

import MetalKit

enum Shader {
    case texture

    enum State {
        case vertex
        case fragment
    }

    enum Name: String {
        case vertexFunction
        case fragmentFunction
    }

    func vertexFunction(library: MTLLibrary) -> MTLFunction? {
        switch self {
        case .texture:
            return library.makeFunction(name: Name.vertexFunction.rawValue)
        }
    }

    func fragmentFunction(library: MTLLibrary) -> MTLFunction? {
        switch self {
        case .texture:
            return library.makeFunction(name: Name.fragmentFunction.rawValue)
        }
    }
}
