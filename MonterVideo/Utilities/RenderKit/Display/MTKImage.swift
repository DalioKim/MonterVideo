////
////  MTKImage.swift
////  MonterVideo
////
////  Created by 김동현 on 8/28/24.
////
//
import MetalKit
import SwiftUI
import Foundation

struct MTKImage: NSViewRepresentable {
    typealias NSViewType = MTKView
    var img: CGImage
    var render = RenderEngine()

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = render.device
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

        init(_ parent: MTKImage) {
            self.parent = parent
        }

        func draw(in view: MTKView) {
            let vertices: [TextureVertex] = [
                TextureVertex(position: simd_float2(-1, -1), texCoord: simd_float2(0.0, 1.0)),
                TextureVertex(position: simd_float2(1, -1), texCoord: simd_float2(1.0, 1.0)),
                TextureVertex(position: simd_float2(1, 1), texCoord: simd_float2(1.0, 0.0)),

                TextureVertex(position: simd_float2(-1, -1), texCoord: simd_float2(0.0, 1.0)),
                TextureVertex(position: simd_float2(1, 1), texCoord: simd_float2(1.0, 0.0)),
                TextureVertex(position: simd_float2(-1, 1), texCoord: simd_float2(0.0, 0.0))
            ]

            parent.render.generateResource(vertices: vertices, image: parent.img)
            parent.render.implementPipeline(view: view, shader: .texture)
            parent.render.commandDraw(view: view)
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    }
}
