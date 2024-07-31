//
//  VideoAsset.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//

import Foundation

struct VideoAsset: Identifiable, Hashable {
    var id = UUID()
    var title: String?
    var url: URL
}
