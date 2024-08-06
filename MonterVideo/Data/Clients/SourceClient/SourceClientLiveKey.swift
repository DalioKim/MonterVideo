//
//  LiveKey.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/08/01.
//

import Dependencies

extension SourceClient: DependencyKey {
    public static let liveValue = {
        return Self(
            load: { url in
                VideoAsset(url: url)
            }
        )
    }()
}
