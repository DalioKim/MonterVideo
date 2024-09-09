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
    private var pipelineState: MTLRenderPipelineState?
    private var vertexBuffer: MTLBuffer?
    private var texture: MTLTexture?
    private typealias TextureBuffers = (vertex: MTLBuffer, texture: MTLTexture)
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        
        self.device = device
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        
        self.commandQueue = queue
        
        guard let library = self.device.makeDefaultLibrary() else {
            fatalError("Could not create Metal library")
        }
        
        self.library = library
    }
    
    func generateResource(vertices: [TextureVertex],
                          image: CGImage) {
        
        vertexBuffer(with: vertices)
        try? loadTexture(with: image)
    }
    
    func implementPipeline(view: MTKView,
                           shader: Shader) {
        guard let descriptor = makeDescriptor(shader: shader, pixelFormat: view.colorPixelFormat) else {
            return
        }
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            print("Failed to create render pipeline state")
        }
    }
    
    func commandDraw(view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderpass = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable,
              let vertexBuffer = self.vertexBuffer,
              let texture = self.texture else {
            return
        }
        
        encodeCommand(renderpass: renderpass, vertexBuffer: vertexBuffer, texture: texture, commandBuffer: commandBuffer)
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

private extension RenderEngine {
    private func vertexBuffer(with vertices: [TextureVertex]) {
        self.vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<TextureVertex>.stride, options: [])
    }
    
    private func loadTexture(with image: CGImage) throws {
        let loader = MTKTextureLoader(device: device)
        do {
            self.texture = try loader.newTexture(cgImage: image)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    private func makeDescriptor(shader: Shader, pixelFormat: MTLPixelFormat) -> MTLRenderPipelineDescriptor? {
        guard let vertexFunction = shader.vertexFunction(library: self.library),
              let fragmentFunction = shader.fragmentFunction(library: self.library) else {
            return nil
        }
        return MTLRenderPipelineDescriptor(textureShaders: [vertexFunction, fragmentFunction],
                                           vertexDescriptor: MTLVertexDescriptor(shader),
                                           pixelFormat: pixelFormat)
    }
    
    private func encodeCommand(renderpass: MTLRenderPassDescriptor,
                               vertexBuffer: MTLBuffer,
                               texture: MTLTexture,
                               commandBuffer: MTLCommandBuffer) {
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderpass),
              let pipelineState = self.pipelineState else {
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        configTextureShader(with: renderEncoder, buffers: (vertexBuffer, texture))
        renderEncoder.endEncoding()
    }
    
    private func configTextureShader(with renderEncoder: MTLRenderCommandEncoder, buffers: TextureBuffers) {
        
        renderEncoder.setVertexBuffer(buffers.vertex, offset: 0, index: 30)
        renderEncoder.setFragmentTexture(buffers.texture, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
    }
}
