//
//  ContentView.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/07.
//

import ComposableArchitecture
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        ClipView(
          store: Store(initialState: Clip.State()) {
              Clip()
          }
        )
        .frame(width: 1000, height: 1000)
    }
    
    private var thumbnailView: some View {
        DragableImage()
    }

}
