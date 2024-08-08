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
        var thumbnails: [FrameThumbnail]
        init(thumbnails: [FrameThumbnail] = []) {
            self.thumbnails = thumbnails
        }
    }

    enum Action: Equatable {
        case onAppear
        case onDisappear
        case loadClip(URL)
        case response([FrameThumbnail])
        //        case trim(VideoAsset)
        //        case response([FrameThumbnail])

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
                            try trimFrame(VideoAsset(url: url), videoAssetClient: videoAssetClient)
                        )
                    )
                }

            case .response(let thumbnails):
                print("thumbnails \(thumbnails)")
                state.thumbnails = thumbnails
                return .none

                //            case .trim(let asset):
                //                return .run { send in
                //                    await send(
                //                        .response(
                //                            try trimFrame(asset, videoGenerateClient: videoGenerateClient)
                //                        )
                //                    )
                //                }
                //
            }
        }
    }
}
