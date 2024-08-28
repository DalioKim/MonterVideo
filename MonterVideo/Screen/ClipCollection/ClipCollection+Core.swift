//
//  ClipCollection+Core.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ClipCollection {
    @ObservableState
    struct State: Equatable {
        var clips: IdentifiedArrayOf<Clip.State>

        init(clips: IdentifiedArrayOf<Clip.State> = []) {
            self.clips = clips
        }
    }

    enum Action: Equatable {
        case onAppear
        case onDisappear
        case loadClip(URL)
        case response(VideoAsset)
        case clipAcion(IdentifiedActionOf<Clip>)

        // subscription each clip(drag event시 지정된 Range도 확인
        // Set the range
    }

    @Dependency(\.videoAssetClient) var videoAssetClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onDisappear:
                return .none

            case .loadClip(let url):
                return .run { send in
                    await send(
                        .response(
                            try loadVideo(url, assetClient: videoAssetClient)
                        )
                    )
                }

            case .response(let asset):
                state.clips.append(.init(with: asset))
                return .none

            case .clipAcion:
                return .none
            }
        }
        .forEach(\.clips, action: \.clipAcion) {
            Clip()
        }
    }
}
