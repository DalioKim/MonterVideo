//
//  FrameTrimHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import ComposableArchitecture

public func trimFrame(
    _ assset: VideoAsset,
    videoGenerateClient: VideoGenerateClient
) throws -> [FrameThumbnail] {
    return try videoGenerateClient.trimThumbnail(assset)
}
