//
//  PipelineDescriptor.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import Metal
import MetalKit

public extension MTLRenderPipelineDescriptor {
    convenience init(functions: [MTLFunction], pixelformat: MTLPixelFormat, vertexDescritor: MTLVertexDescriptor) {
        self.init()
        self.vertexFunction = functions[0]
        self.fragmentFunction = functions[1]
        self.vertexDescriptor = vertexDescritor
        self.colorAttachments[0].pixelFormat = pixelformat
    }
    
    private func didSetFunction() {
    }
}
