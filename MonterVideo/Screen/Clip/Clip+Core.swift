//
//  Clip.swift
//  MonterVideo
//
//  Created by 김동현 on 8/19/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Clip {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id = UUID()
        let asset: VideoAsset?
        var thumbnails = [FrameThumbnail]()

        init(with asset: VideoAsset? = nil) {
            self.asset = asset
        }
    }

    enum Action: Equatable {
        case onAppear
        case onDisappear
        case response([FrameThumbnail])
    }

    @Dependency(\.videoAssetClient) var videoAssetClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard let asset = state.asset else { return .none }

                return .run { send in
                    await send(
                        .response(
                            try trimFrame(asset, videoAssetClient: videoAssetClient)
                        )
                    )
                }

            case .onDisappear:
                return .none

            case .response(let thumbnails):
                state.thumbnails = thumbnails
                return .none
            }
        }
    }
}
