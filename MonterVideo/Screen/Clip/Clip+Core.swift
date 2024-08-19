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
    struct State: Equatable {
        let asset: VideoAsset
        var thumbnails = [FrameThumbnail]()
        init(asset: VideoAsset) {
            self.asset = asset
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case onDisappear
        case response([FrameThumbnail])
        
        // subscription each clip(drag event시 지정된 Range도 확인
        // Set the range
    }
    
    @Dependency(\.videoAssetClient) var videoAssetClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let asset = state.asset
                
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
