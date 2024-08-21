//
//  Clip+Core.swift
//  MonterVideo
//
//  Created by 김동현 on 8/12/24.
//

import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
struct ClipDelegateReducer {
    public struct State: Equatable {
      public init() {}
    }

    enum Action: Equatable {
        case trim(VideoAsset)
        case reviseSpan
    }

    @Dependency(\.videoAssetClient) var videoAssetClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case .trim(let asset):
                return .run { send in
                    await send(
                        .response(
                            try trimFrame(asset, videoAssetClient: videoAssetClient)
                        )
                    )
                }

            case .reviseSpan():
                return .none
            }
        }
    }
}
