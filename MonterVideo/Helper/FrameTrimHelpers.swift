//
//  FrameTrimHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

public func trimFrame(
    _ asset: VideoAsset,
    videoAssetClient: VideoAssetClient
) async throws -> [FrameThumbnail] {
    return try await videoAssetClient.trimThumbnail(asset)
}
