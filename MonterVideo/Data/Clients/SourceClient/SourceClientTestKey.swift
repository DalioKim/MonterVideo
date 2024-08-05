//
//  TestKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import Dependencies

extension DependencyValues {
  public var sourceClient: SourceClient {
    get { self[SourceClient.self] }
    set { self[SourceClient.self] = newValue }
  }
}

