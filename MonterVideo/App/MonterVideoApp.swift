//
//  MonterVideoApp.swift
//  MonterVideo
//
//  Created by 김동현 on 2024/06/07.
//

import SwiftUI

@main
struct MonterVideoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
