//
//  VideoAsset.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import Foundation

public struct VideoAsset: Identifiable, Hashable {
    public var id = UUID()
    var url: URL
}
