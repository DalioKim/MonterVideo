//
//  Spacing.swift
//  MonterVideo
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

public enum Spacing: CGFloat {
    case none = 0
    case xxxSmall = 2
    case xxSmall = 4
    case xSmall = 8
    case small = 12
    case medium = 16
    case xMedium = 20
    case large = 24
    case xLarge = 32
    case xxLarge = 44
    case xxxLarge = 60
}

public extension CGFloat {
    static let none = Spacing.none.rawValue
    static let xxxSmall = Spacing.xxxSmall.rawValue
    static let xxSmall = Spacing.xxSmall.rawValue
    static let xSmall = Spacing.xSmall.rawValue
    static let small = Spacing.small.rawValue
    static let medium = Spacing.medium.rawValue
    static let xMedium = Spacing.xMedium.rawValue
    static let large = Spacing.large.rawValue
    static let xLarge = Spacing.xLarge.rawValue
    static let xxLarge = Spacing.xxLarge.rawValue
    static let xxxLarge = Spacing.xxxLarge.rawValue
}
