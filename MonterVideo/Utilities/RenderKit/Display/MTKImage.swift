//
//  MTKImage.swift
//  MonterVideo
//
//  Created by 김동현 on 8/28/24.
//

import MetalKit
import SwiftUI
import Foundation

struct MTKImage: NSViewRepresentable {
    typealias NSViewType = MTKView
    var img: CGImage
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.delegate = context.coordinator
        view.framebufferOnly = true
        view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension MTKImage {
    final class Coordinator: NSObject, MTKViewDelegate {
        var parent: MTKImage
        
        var device: MTLDevice?
        var renderPipelineState: MTLRenderPipelineState?
        
        var vertexBuffer: MTLBuffer?
        var indexBuffer: MTLBuffer?
        var colorTexture: MTLTexture?
        
        init(_ parent: MTKImage) {
            self.parent = parent
        }
        
        func draw(in view: MTKView) {
            implementPipeline(view: view)
            defineVertex(view: view)
            loadTexture(view: view)
            submitRendering(view: view)
        }
        
        func temp(in view: MTKView) {
            
        }
        
        
        func implementPipeline(view: MTKView) {
            let vertexDescriptor = MTLVertexDescriptor()
            vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.stride
            vertexDescriptor.layouts[30].stepRate = 1
            vertexDescriptor.layouts[30].stepFunction = MTLVertexStepFunction.perVertex
            
            vertexDescriptor.attributes[0].format = MTLVertexFormat.float2
            vertexDescriptor.attributes[0].offset = 8
            vertexDescriptor.attributes[0].bufferIndex = 30
            
            vertexDescriptor.attributes[1].format = MTLVertexFormat.float2
            vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
            vertexDescriptor.attributes[1].bufferIndex = 30
            
            let library = view.device!.makeDefaultLibrary()!
            let vertexFunction = library.makeFunction(name: "vertexFunction")!
            let fragmentFunction = library.makeFunction(name: "fragmentFunction")!
            
            let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
            renderPipelineStateDescriptor.vertexFunction = vertexFunction
            renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
            renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
            renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            
            do {
                self.renderPipelineState = try view.device!.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
            } catch {
                print("Failed to create render pipeline state")
            }
        }
        
        func defineVertex(view: MTKView) {
            let vertices: [Vertex] = [
                Vertex(position: simd_float2(-1, -1), texCoord: simd_float2(0.0, 1.0)), // vertex 0
                Vertex(position: simd_float2( 1, -1), texCoord: simd_float2(1.0, 1.0)), // vertex 1
                Vertex(position: simd_float2( 1, 1), texCoord: simd_float2(1.0, 0.0)), // vertex 2
                Vertex(position: simd_float2(-1, 1), texCoord: simd_float2(0.0, 0.0))  // vertex 3
            ]
            
            self.vertexBuffer = view.device!.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout.stride(ofValue: vertices[0]), options: MTLResourceOptions.storageModeShared)!
            
            let indices: [ushort] = [
                0, 1, 2,
                0, 2, 3
            ]
            
            self.indexBuffer = view.device!.makeBuffer(bytes: indices, length: indices.count * MemoryLayout.stride(ofValue: indices[0]), options: MTLResourceOptions.storageModeShared)!
        }
        
        func loadTexture(view: MTKView) {
            let loader = MTKTextureLoader(device: view.device!)
            
            do {
                self.colorTexture = try loader.newTexture(cgImage: self.parent.img)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
        
        func submitRendering(view: MTKView) {
            let commandQueue = view.device!.makeCommandQueue()
            let commandBuffer = commandQueue!.makeCommandBuffer()
            let renderPassDescriptor = view.currentRenderPassDescriptor!
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            
            renderEncoder.setRenderPipelineState(self.renderPipelineState!)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 30)
            renderEncoder.setFragmentTexture(colorTexture, index: 0)
            renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle, indexCount: 6, indexType: MTLIndexType.uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
            renderEncoder.endEncoding()
            
            let drawable = view.currentDrawable!
            commandBuffer!.present(drawable)
            commandBuffer!.commit()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    }
}
