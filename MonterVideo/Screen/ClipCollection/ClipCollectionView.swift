//
//  ClipCollectionView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import ComposableArchitecture
import SwiftUI

struct ClipCollectionView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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
            ScrollView {
                LazyVGrid(columns: adaptiveColumn(reader.size.width), spacing: .small) {
                    ForEach(store.scope(state: \.clips, action: \.clipAcion)) { store in
                        ClipView(store: store)
                            .frame(minHeight: reader.size.height.eightAreas)
                    }
                }
                .padding(.bottom)
            }
        }
    }

    private func adaptiveColumn(_ width: CGFloat) -> [GridItem] {
        return [GridItem(.adaptive(minimum: width.eightAreas), spacing: .none)]
    }
}
