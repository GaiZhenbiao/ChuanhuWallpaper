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
    @State private var wallpapers = [WallpaperImage]()
    @State private var bottomBarHeight = CGFloat.zero
    @State private var mode = WallpaperMode.appearance
    @Namespace private var paper
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if mode != .appearance {
                    DynamicWallpaperView(wallpapers: $wallpapers, namespace: paper, mode: $mode)
                } else {
                    AppearanceWallpaperView(wallpapers: $wallpapers, namespace: paper)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroud)
            .padding(.bottom, bottomBarHeight)
            
            SaveButton(wallpapers: wallpapers, mode: mode)
                .frame(maxWidth: .infinity)
                .overlay(
                    Button {
                        withAnimation {
                            wallpapers.removeAll()
                        }
                    } label: {
                        Label {
                            Text("Remove All")
                                .foregroundColor(.red)
                        } icon: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                    }
                        .offset(x: wallpapers.isEmpty ? 200 : 0)
                        .animation(.spring(), value: wallpapers)
                    , alignment: .trailing
                )
                .overlay(
                    ModePicker(mode: $mode)
                    , alignment: .leading
                )
                .padding()
                .buttonStyle(.standard)
                .background(
                    Color.backgroud
                        .shadow(color: Color.black.opacity(0.05), radius: 5, y: -1)
                )
                .overlay(bottombarReader)
        }
    }
    
    private var bottombarReader: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    bottomBarHeight = proxy.size.height
                }
                .onChange(of: proxy.size.height) {
                    bottomBarHeight = $0
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
