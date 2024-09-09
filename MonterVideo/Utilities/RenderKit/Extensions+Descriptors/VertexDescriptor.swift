//
//  VertexDescriptor.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import Metal
import MetalKit

extension MTLVertexDescriptor {
    convenience init(_ shader: Shader) {
        self.init()
        didsetLayouts(with: shader)
        didsetAttributes(with: shader)
    }
    private func didsetLayouts(with shader: Shader) {
        switch shader {
        case .texture:
            self.layouts[30].stride = MemoryLayout<TextureVertex>.stride
            self.layouts[30].stepRate = 1
            self.layouts[30].stepFunction = MTLVertexStepFunction.perVertex
        }
    }

    private func didsetAttributes(with shader: Shader) {
        switch shader {
        case .texture:
            self.attributes[0].format = MTLVertexFormat.float2
            self.attributes[0].offset = MemoryLayout.offset(of: \TextureVertex.position)!
            self.attributes[0].bufferIndex = 30

            self.attributes[1].format = MTLVertexFormat.float2
            self.attributes[1].offset = float2.size
            self.attributes[1].bufferIndex = 30
        }
    }
}
