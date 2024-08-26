//
//  FrameRatio.swift
//  MonterVideo
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

public enum SizeRatio: CGFloat {
    case twoAreas = 0.49
    case threeAreas = 0.32
    case fourAreas = 0.24
    case fiveAreas = 0.19
    case sixAreas = 0.15
    case sevenAreas = 0.11
    case eightAreas = 0.1
}

extension CGFloat {
    var twoAreas: CGFloat { return self * SizeRatio.twoAreas.rawValue }
    var threeAreas: CGFloat { return self * SizeRatio.threeAreas.rawValue }
    var fourAreas: CGFloat { return self * SizeRatio.fourAreas.rawValue }
    var fiveAreas: CGFloat { return self * SizeRatio.fiveAreas.rawValue }
    var sixAreas: CGFloat { return self * SizeRatio.sixAreas.rawValue }
    var sevenAreas: CGFloat { return self * SizeRatio.sevenAreas.rawValue }
    var eightAreas: CGFloat { return self * SizeRatio.eightAreas.rawValue }
}
