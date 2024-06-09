//
//  ClipCore.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/30.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Clip {
    @ObservableState
    struct State: Equatable { /* ... */ }
    enum Action: Equatable {
        case onAppear
        case onDisappear
        case drag
        case drop
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .onDisappear:
                return .none
                
            case .drag:
                return .none
                
            case .drop:
                return .none
            }
        }
    }
}
