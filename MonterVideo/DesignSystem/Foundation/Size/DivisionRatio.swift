//
//  DivisionRatio.swift
//  MonterVideo
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

public enum DivisionRatio: CGFloat {
    case two = 0.5
    case three = 0.33
    case four = 0.25
    case five = 0.2
    case six = 0.16
    case seven = 0.14
    case eight = 0.12
}

extension CGFloat {
    func devidedSize(_ devide: DivisionRatio, spacing: CGFloat) -> CGFloat {
        return self * devide.rawValue - spacing / 2
    }

    func devidedSize(_ devide: DivisionRatio, spacing: Spacing) -> CGFloat {
        return self * devide.rawValue - spacing.rawValue / 2
    }
}
