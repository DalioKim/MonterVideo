//
//  VideoLoaderClient.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import DependenciesMacros
import Foundation

@DependencyClient
public struct SourceClient {
    public var load: @Sendable (URL) throws -> VideoAsset
}
