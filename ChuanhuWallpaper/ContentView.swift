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
    @State private var selectedWallpaper: WallpaperImage?
    @State private var bottomBarHeight = CGFloat.zero
    @State private var type = WallPaperType.solar
    @Namespace private var paper
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                DynamicWallpaperView(wallpapers: $wallpapers, selectedWallpaper: $selectedWallpaper, namespace: paper, type: $type)
                    .background(Color.backgroud)
                    .padding(.bottom, bottomBarHeight)
                
                SaveButton(wallpapers: wallpapers)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Button {
                            withAnimation(.spring()) {
                                wallpapers.removeAll()
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                            .offset(x: wallpapers.isEmpty ? 100 : 0)
                            .animation(.spring(), value: wallpapers)
                        , alignment: .trailing
                    )
                    .overlay(
                        Group {
                            switch type {
                            case .time:
                                Button("Switch to Solar Mode") {
                                    type = .solar
                                }
                            case .solar:
                                Button("Switch to Time Mode") {
                                    type = .time
                                }
                                .multilineTextAlignment(.leading)
                            }
                        }
                            .buttonStyle(.link)
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
