//
//  FrameThumbnail.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/07/31.
//
import Foundation
import SwiftUI

public struct FrameThumbnail: Identifiable, Hashable {
    public var id = UUID()
    public var img: CGImage
}
