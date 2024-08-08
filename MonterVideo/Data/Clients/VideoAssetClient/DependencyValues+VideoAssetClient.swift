//
//  TestKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Dependencies

extension DependencyValues {
  public var videoGenerateClient: VideoAssetClient {
    get { self[VideoAssetClient.self] }
    set { self[VideoAssetClient.self] = newValue }
  }
}
