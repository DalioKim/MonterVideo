//
//  SourceView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct SourceView: View {
    @ObservedObject var generateClient: VideoGenerateClient
    @ObservedObject var loaderClient: VideoLoaderClient
    @State private var isImporting: Bool = false

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            importBtn
            gridThumbnails
        }
    }
    
    init() {
        let loaderClient = VideoLoaderClient()
        self.loaderClient = loaderClient
        self.generateClient = VideoGenerateClient(client: loaderClient)
    }
}

extension SourceView {
    private var importBtn: some View {
        Button(action: {
        }, label: {
            Text("Import Resource")
        })
        .buttonStyle(ImportVideoStyle(client: loaderClient))
    }
        
    private var gridThumbnails: some View {
        ScrollView{
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                ForEach(generateClient.thumbnails, id: \.self) { item in
                    let myNsImage = NSImage(cgImage: item.img, size: .init(width: 100, height: 100))
                    Image(nsImage: myNsImage)
                }
            }
        }
        .padding()
    }
}
