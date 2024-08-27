//
//  VideoLoadHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Foundation

public func loadVideo(
    _ url: URL,
    assetClient: VideoAssetClient
) throws -> VideoAsset {
     return try assetClient.load(url)
}
