//
//  VideoAsset.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import AVFoundation
import Foundation

public struct VideoAsset: Identifiable, Hashable {
    public var id = UUID()
    var url: URL
    var asset: AVAsset
    var duration: CMTime

    init(url: URL) {
        self.url = url
        self.asset = AVAsset(url: url)

        // need Fix
        self.duration = asset.duration
    }
}
