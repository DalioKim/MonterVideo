//
//  ClipView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/30.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct ClipView: View {
    var store: StoreOf<Clip>
    
    var body: some View {
        VStack {
            thumbnailView.frame(width: 1000, height: 100)
            audioView.frame(width: 100, height: 100)
        }

    }
}

// MARK: - SubViews

extension ClipView {
    
    // MARK: - Temps
    
    private var thumbnailView: some View {
        DragableImage()
    }
    
    private var audioView: some View {
        Text("audioView")
    }
}
