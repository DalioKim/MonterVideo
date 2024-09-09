//
//  PipelineDescriptorClient.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import Metal

extension MTLRenderPipelineDescriptor {
    convenience init(textureShaders: [MTLFunction],
                     vertexDescriptor: MTLVertexDescriptor,
                     pixelFormat: MTLPixelFormat) {
        self.init()
        self.vertexFunction = textureShaders[0]
        self.fragmentFunction = textureShaders[1]
        self.vertexDescriptor = vertexDescriptor
        self.colorAttachments[0].pixelFormat = pixelFormat
    }
}
