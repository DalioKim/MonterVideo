//
//  Thumbnail.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//
import Foundation
import SwiftUI

struct FrameThumbnail: Identifiable, Hashable {
    var id = UUID()
    var img: CGImage
}
