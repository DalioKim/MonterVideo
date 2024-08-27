//
//  ClipView.swift
//  MonterVideo
//
//  Created by 김동현 on 8/19/24.
//

import ComposableArchitecture
import SwiftUI

struct ClipView: View {
    var store: StoreOf<Clip>

    public init(store: StoreOf<Clip>) {
        self.store = store
        store.send(.onAppear)
    }

    var body: some View {
        ForEach(store.state.thumbnails, id: \.self) { item in
            GeometryReader { reader in
                let thumbnail = NSImage(cgImage: item.img, size: .init(width: reader.size.width, height: reader.size.height))
                Image(nsImage: thumbnail)
            }
        }
    }
}
