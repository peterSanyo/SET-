//
//  SET_App.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

@main
struct SET_App: App {
    @StateObject var setGame = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(setGame: SetGameViewModel())
        }
    }
}
