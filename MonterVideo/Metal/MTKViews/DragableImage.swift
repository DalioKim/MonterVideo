//
//  DragableImage.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/30.
//

import MetalKit
import SwiftUI

struct DragableImage: NSViewRepresentable {
    typealias NSViewType = MTKView
    var modelMatrix = matrix_identity_float4x4

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) { }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension DragableImage {
    class Coordinator: NSObject, MTKViewDelegate, NSGestureRecognizerDelegate {
        //        var vertices: [Vertex]!
        //        var vertexBuffer: MTLBuffer!
        var defaultPosition: Float = 0
        //        var player = Player()
        var parent: DragableImage
        
        var commandQueue: MTLCommandQueue!
        var renderPipelineState: MTLRenderPipelineState!
        
        var vertexBuffer: MTLBuffer!
        var vertices = [
            Vertex(position: float3( 1, 1,0), color: float4(1,0,0,1)), //Top Right
            Vertex(position: float3(-1, 1,0), color: float4(0,1,0,1)), //Top Left
            Vertex(position: float3(-1,-1,0), color: float4(0,0,1,1)),  //Bottom Left
            
            Vertex(position: float3( 1, 1,0), color: float4(1,0,0,1)), //Top Right
            Vertex(position: float3(-1,-1,0), color: float4(0,0,1,1)), //Bottom Left
            Vertex(position: float3( 1,-1,0), color: float4(1,0,1,1))  //Bottom Right
        ]
        
        var position = SIMD3<Float>(0,0,0)
        var scale = SIMD3<Float>(1,1,1)
        var rotation = SIMD3<Float>(0,0,0)


//        var modelMatrix: matrix_float4x4{
//            var modelMatrix = matrix_identity_float4x4
//            modelMatrix.translate(direction: position)
//            return modelMatrix
//        }

        
        init(_ parent: DragableImage) {
            self.parent = parent
            
        }
        func draw(in view: MTKView) {
            createCommandQueue(device: view.device!)
            createPipelineState(device: view.device!)
            createBuffers(device: view.device!)
            setGesture(view: view)
            
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
            }
            // Create a buffer from the commandQueue
            let commandBuffer = commandQueue.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            
            commandEncoder?.setVertexBytes(&parent.modelMatrix, length: ModelConstants.stride, index: 1)
            commandEncoder?.setRenderPipelineState(renderPipelineState)
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
            
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
            
        }
        
        //MARK: Builders
        func createCommandQueue(device: MTLDevice) {
            commandQueue = device.makeCommandQueue()
        }
        
        func createPipelineState(device: MTLDevice) {
            // The device will make a library for us
            let library = device.makeDefaultLibrary()
            // Our vertex function name
            let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
            // Our fragment function name
            let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")

            // Create basic descriptor
            let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
            // Attach the pixel format that si the same as the MetalView
            renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            //Position
            let vertexDescriptor = MTLVertexDescriptor()
            vertexDescriptor.attributes[0].format = .float3
            vertexDescriptor.attributes[0].bufferIndex = 0
            vertexDescriptor.attributes[0].offset = 0
            
            //Color
            vertexDescriptor.attributes[1].format = .float4
            vertexDescriptor.attributes[1].bufferIndex = 0
            vertexDescriptor.attributes[1].offset = float3.size
            
            vertexDescriptor.layouts[0].stride = Vertex.stride

            // Attach the shader functions
            renderPipelineDescriptor.vertexFunction = vertexFunction
            renderPipelineDescriptor.fragmentFunction = fragmentFunction
            renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
            // Try to update the state of the renderPipeline
            do {
                renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func createBuffers(device: MTLDevice) {
            vertexBuffer = device.makeBuffer(bytes: vertices,
                                             length: MemoryLayout<Vertex>.stride * vertices.count,
                                             options: [])
        }
        
        func setGesture(view: MTKView) {
            let gesture = NSPanGestureRecognizer(target: self, action:  #selector (self.dragAction (_:)))
            gesture.delegate = self
            view.addGestureRecognizer(gesture)
        }
        
        
        @objc func dragAction(_ gesture: NSPanGestureRecognizer){
            let point = gesture.translation(in: gesture.view)
            let x = Float((point.x / 1000))
            
            let y = Float((point.y / 1000))

            position.x += x
            position.y += y

            parent.modelMatrix.translate(direction: position)
            print(" modelConstants\(parent.modelMatrix)")
        }
        
        
        //        func draw(in view: MTKView) {
        //            Engine.Ignite(device: view.device!)
        //            guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        //
        //            let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        //            let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        //
        //            player.update(deltaTime: 1 / Float(view.preferredFramesPerSecond))
        //
        //            player.render(renderCommandEncoder: renderCommandEncoder!)
        //
        //            renderCommandEncoder?.endEncoding()
        //            commandBuffer?.present(drawable)
        //            commandBuffer?.commit()
        //        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
        
        
    }
}

class Player: GameObject {
    
    init() {
        super.init(meshType: .Quad_Custom)
    }
    
}

class GameObject: Node {
    
    var modelConstants = ModelConstants()
    
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    var time: Float = 0
    func update(deltaTime: Float){
        //        time += deltaTime
        //        self.position = float3(repeating: cos(time))
        //        self.scale = float3(repeating: cos(time))
        
        updateModelConstants()
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
    }
    
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 1)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
    }
}

struct TempVertex {
    var position: float3
    var color: float4
}
