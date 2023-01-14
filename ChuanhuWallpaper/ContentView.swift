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
    
    @State private var selectedTab: Tabs? = Tabs.appearance
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(tag: Tabs.appearance, selection: $selectedTab) {
                    AppearanceWallpaperView()
                        .navigationTitle("Appearance")
                } label: {
                    Label("Appearance", systemImage: "moon.circle")
                }
                NavigationLink(tag: Tabs.solar, selection: $selectedTab) {
                    SolarWallpaperView()
                        .navigationTitle("Solar")
                } label: {
                    Label("Solar", systemImage: "sun.haze")
                }
                NavigationLink(tag: Tabs.time, selection: $selectedTab) {
                    TimeWallpaperView()
                        .navigationTitle("Time")
                } label: {
                    Label("Time", systemImage: "clock")
                }
            }
            .listStyle(.sidebar)
        }
//        TabView {
//            AppearanceWallpaperView()
//                .tabItem {
//                    Label("Appearance", systemImage: "star")
//                }
//                .tag(Tabs.appearance)
//            SolarWallpaperView()
//                .tabItem {
//                    Label("Solar", systemImage: "gear")
//                }
//                .tag(Tabs.solar)
//            TimeWallpaperView()
//                .tabItem {
//                    Label("Time", systemImage: "star")
//                }
//                .tag(Tabs.time)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
