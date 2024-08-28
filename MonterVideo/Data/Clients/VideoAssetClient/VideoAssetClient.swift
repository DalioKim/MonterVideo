//
//  VideoGenerateClient.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import AVFoundation
import ComposableArchitecture
import Foundation

@DependencyClient
public struct VideoAssetClient {
    public var load: @Sendable (URL) throws -> VideoAsset
    public var trimThumbnail: @Sendable (VideoAsset) async throws -> [FrameThumbnail]
    //    public var reviseAssetDuration: @Sendable (VideoAsset) throws -> VideoAsset
}
