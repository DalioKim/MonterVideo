//
//  SourceLoadHelpers.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Combine
import ComposableArchitecture
import Foundation

public func loadSourceAsync(
    _ url: URL,
    sourceClient: SourceClient
) async throws -> VideoAsset {
     return try await sourceClient.load(url)
}

