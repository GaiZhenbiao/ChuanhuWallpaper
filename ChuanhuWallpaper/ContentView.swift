//
//  ContentView.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import SwiftUI
import WallpapperLib

struct windowSize {
    static var minWidth : CGFloat = 100
    static var minHeight : CGFloat = 200
    static var maxWidth : CGFloat = 100
}

struct ContentView: View {
    private enum Tabs: Hashable {
        case solar, time, appearance
    }
    var body: some View {
        TabView {
            AppearanceWallpaperView()
                .tabItem {
                    Label("Appearance", systemImage: "star")
                }
                .tag(Tabs.appearance)
            SolarWallpaperView()
                .tabItem {
                    Label("Solar", systemImage: "gear")
                }
                .tag(Tabs.solar)
            TimeWallpaperView()
                .tabItem {
                    Label("Time", systemImage: "star")
                }
                .tag(Tabs.time)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
