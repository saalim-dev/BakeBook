//
//  BakeBookApp.swift
//  BakeBook
//
//  Created by Rayaan Ismail on 10/4/24.
//

import SwiftUI

@main
struct BakeBookApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color("Primary")
                    .ignoresSafeArea()
                Dashboard()
            }
        }
    }
}

