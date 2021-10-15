//
//  MedicadaApp.swift
//  Medicada
//
//  Created by Everton Cunha on 15/10/21.
//

import SwiftUI

@main
struct MedicadaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
