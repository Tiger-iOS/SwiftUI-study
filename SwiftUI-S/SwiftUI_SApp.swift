//
//  SwiftUI_SApp.swift
//  SwiftUI-S
//
//  Created by imac on 2021/6/17.
//

import SwiftUI

@main
struct SwiftUI_SApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Ring())
        }
    }
}
