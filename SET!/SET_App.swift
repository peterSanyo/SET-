//
//  SET_App.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

/// The entry point of the SET! card game application.
///
/// Key Components:
/// - `@StateObject var setGame`: An instance of `SetGameViewModel`
@main
struct SET_App: App {
    @StateObject var setGame = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(setGame: SetGameViewModel())
        }
    }
}
