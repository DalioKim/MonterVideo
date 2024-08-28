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
        GeometryReader { reader in
            let widthSpacing = CGFloat.none
            let heightSpacing = CGFloat.small
            let gridItemWidth = reader.size.width.devidedSize(.eight, spacing: widthSpacing)
            let gridItemHeight = reader.size.height.devidedSize(.eight, spacing: heightSpacing)

            ScrollView {
                LazyVGrid(columns: adaptiveColumn(gridItemWidth, with: widthSpacing), spacing: heightSpacing) {
                    ForEach(store.scope(state: \.clips, action: \.clipAcion)) { store in
                        ClipView(store: store)
                            .frame(minHeight: gridItemHeight)
                    }
                }
                .padding(.bottom)
            }
        }
    }

    private func adaptiveColumn(_ width: CGFloat, with spacing: CGFloat) -> [GridItem] {
        return [GridItem(.adaptive(minimum: width), spacing: spacing)]
    }
}
