//
//  RenderEngine.swift
//  MonterVideo
//
//  Created by 김동현 on 9/5/24.
//

import Foundation
import MetalKit

public class RenderEngine {
    public let device: MTLDevice
    private let library: MTLLibrary
    private let commandQueue: MTLCommandQueue
    private let commandBuffer: MTLCommandBuffer
    private var pipelineState: MTLRenderPipelineState?
    //    public let semantic: Semantic
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        self.device = device
        
        guard let library = self.device.makeDefaultLibrary() else {
            fatalError("Could not create Metal Device")
        }
        self.library = library
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = queue
        
        guard let buffer = self.commandQueue.makeCommandBuffer() else {
            fatalError("Could not create command queue")
        }
        self.commandBuffer = buffer
    }
    
//    func commandDraw(renderpass: MTLRenderPassDescriptor,
//                     descriptor: MTLRenderPipelineDescriptor,
//                     drawable: CAMetalDrawable,
//                     vertexBuffer: MTLBuffer,
//                     indexBuffer: MTLBuffer,
//                     texture: MTLTexture) {
//        implementPipeline(descriptor: descriptor)
//        encodeCommand(renderpass: renderpass, vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, texture: texture)
//        
//        commandBuffer.present(drawable)
//        commandBuffer.commit()
//    }
    
    func commandDraw(renderpass: MTLRenderPassDescriptor,
                         shader: Shader,
                         drawable: CAMetalDrawable,
                         pixelFormat: MTLPixelFormat,
                         vertexBuffer: MTLBuffer,
                         indexBuffer: MTLBuffer,
                         texture: MTLTexture) {
        
        guard let descriptor = makeDescriptor(shader: shader, pixelFormat: pixelFormat) else { return }
        
        implementPipeline(descriptor: descriptor)
        encodeCommand(renderpass: renderpass, vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, texture: texture)
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    
    func loadTexture(image: CGImage) throws -> MTLTexture {
        let loader = MTKTextureLoader(device: device)
        
        do {
            return try loader.newTexture(cgImage: image)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}

// Private

extension RenderEngine {
    func makeDescriptor(shader: Shader, pixelFormat: MTLPixelFormat) -> MTLRenderPipelineDescriptor? {
        guard let vertexFunction = shader.vertexFunction(library: library),
              let fragmentFunction = shader.fragmentFunction(library: library) else {
            return nil
        }
        
        return MTLRenderPipelineDescriptor(textureShaders: [vertexFunction, fragmentFunction],
                                           vertexDescriptor: MTLVertexDescriptor(shader),
                                           pixelFormat: pixelFormat)
    }
}

// Private

extension RenderEngine {
    func implementPipeline(descriptor: MTLRenderPipelineDescriptor) {
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            print("Failed to create render pipeline state")
        }
    }
    
    
    func encodeCommand(renderpass: MTLRenderPassDescriptor,
                       vertexBuffer: MTLBuffer,
                       indexBuffer: MTLBuffer,
                       texture: MTLTexture) {
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderpass),
              let pipelineState = self.pipelineState else {
            fatalError("Could not create command queue")
        }
        
        configTextureShader(with: renderEncoder, buffers: (vertexBuffer, indexBuffer, texture))
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.endEncoding()
    }
}

// Private Config
// Call different functions based on the render type (basic, image, draggable, etc.)

extension RenderEngine {
    typealias TextureBuffers = (vertex: MTLBuffer, index: MTLBuffer, texture:MTLTexture)
    
    func configTextureShader(with renderEncoder: MTLRenderCommandEncoder, buffers: TextureBuffers) {
        renderEncoder.setVertexBuffer(buffers.vertex, offset: 0, index: 30)
        renderEncoder.setFragmentTexture(buffers.texture, index: 0)
        renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle, indexCount: 6, indexType: MTLIndexType.uint16, indexBuffer: buffers.index, indexBufferOffset: 0)
    }
}
