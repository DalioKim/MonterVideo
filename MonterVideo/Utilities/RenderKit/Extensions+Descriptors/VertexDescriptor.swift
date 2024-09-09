//
//  VertexDescriptor.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import Metal
import MetalKit

public enum Semantic: Hashable, Sendable {
    case position
    case normal
    case textureCoordinate
    // TODO: Add in more semantics. (From ModelIO semantics and GLTF etc)
}

extension Semantic: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .position:
            try container.encode("position")
        case .normal:
            try container.encode("normal")
        case .textureCoordinate:
            try container.encode("textureCoordinate")
        }
    }
}
