//
//  mawaddah_iosApp.swift
//  mawaddah-ios
//
//  Created by Haikal Tahar on 21/05/2025.
//

import SwiftUI

@main
struct MawaddahiOSApp: App {
  @StateObject private var personStore = PersonStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(personStore)
    }
  }
}
