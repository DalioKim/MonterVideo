//
//  SourceCore.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Source {
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
        case update(URL)
        case trim(VideoAsset)
        case response([FrameThumbnail])
    }
    
    @Dependency(\.sourceClient) var sourceClient
    @Dependency(\.videoGenerateClient) var videoGenerateClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .onDisappear:
                return .none
                
            case .update(let url):
//                print("update \()")
                return .run { send in
                    await send(
                        .trim(
                            try await loadSourceAsync(url, sourceClient: sourceClient)
                        )
                    )
                }
                
            case .trim(let asset):
                return .run { send in
                    await send(
                        .response(
                            try await trimFrameAsync(asset, videoGenerateClient: videoGenerateClient)
                        )
                    )
                }
                
            case .response(let thumbnails):
                state.thumbnails = thumbnails
                print("state \(thumbnails.count)")
                return .none
            }
        }
    }
}
