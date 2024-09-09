//
//  MainView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/07.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            ClipCollectionView()
        }
    }

}
