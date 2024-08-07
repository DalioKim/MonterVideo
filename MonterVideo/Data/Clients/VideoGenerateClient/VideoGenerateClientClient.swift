//
//  VideoGenerateClient.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import DependenciesMacros

@DependencyClient
public struct VideoGenerateClient {
    public var trimThumbnail: @Sendable (VideoAsset) throws -> [FrameThumbnail]
}