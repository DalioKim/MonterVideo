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

        // TODO: Modify the declaration position.
        store.send(.onAppear)
    }

    var body: some View {
        ForEach(store.state.thumbnails, id: \.self) { item in
            GeometryReader { _ in
                MTKImage(img: item.img)
            }
        }
    }
}
