//
//  SourceLoadHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Foundation

public func loadSource(
    _ url: URL,
    sourceClient: SourceClient
) throws -> VideoAsset {
     return try sourceClient.load(url)
}
