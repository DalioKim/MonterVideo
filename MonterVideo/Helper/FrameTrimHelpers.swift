//
//  FrameTrimHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Combine
import ComposableArchitecture
import Foundation

public func trimFrameAsync(
    _ assset: VideoAsset,
    videoGenerateClient: VideoGenerateClient
) async throws -> [FrameThumbnail] {
    return try await videoGenerateClient.trimThumbnail(assset)
}
