//
//  SourceView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import ComposableArchitecture
import SwiftUI

struct SourceView: View {
    @State private var isImporting: Bool = false
    
    var store: StoreOf<Source>

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            importBtn
            gridThumbnails
        }
    }
    
    public init() {
        let store = Store(initialState: Source.State()) {
            Source()
        }
      self.store = store
    }
}

extension SourceView {
    private var importBtn: some View {
        Button(action: {
            isImporting = true
        }, label: {
            Text("Import Resource")
        })
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: [.mpeg4Movie],
                      onCompletion: { result in
            
            switch result {
            case .success(let url):
                store.send(.update(url), animation: .default)
            case .failure(let error):
                print(error)
            }
        })
    }
        
    private var gridThumbnails: some View {
        ScrollView{
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                ForEach(store.state.thumbnails, id: \.self) { item in
                    let myNsImage = NSImage(cgImage: item.img, size: .init(width: 100, height: 100))
                    Image(nsImage: myNsImage)
                        .onAppear {
                            print("state item \(item)")
                        }

                }
            }
        }
        .padding()
    }
}
