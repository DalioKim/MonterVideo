//
//  ClipCollectionView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import ComposableArchitecture
import SwiftUI

struct ClipCollectionView: View {
    @State private var isImporting: Bool = false

    var store: StoreOf<ClipCollection>

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
        let store = Store(initialState: ClipCollection.State()) {
            ClipCollection()
        }
      self.store = store
    }
}

extension ClipCollectionView {
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
                store.send(.loadClip(url), animation: .default)
            case .failure(let error):
                print(error)
            }
        })
    }

    private var gridThumbnails: some View {
        ScrollView {
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
