//
//  AppearanceWallpaperView.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//  Recreated by LiYanan2004 on 2023/1/29.
//

import SwiftUI
import FilePicker
import WallpapperLib

struct AppearanceWallpaperView: View {
    @Binding var wallpapers: [WallpaperImage]
    var namespace: Namespace.ID
    
    var lightWallpaper: Binding<WallpaperImage> {
        Binding<WallpaperImage> {
            wallpapers.first(where: { $0.isFor == .light }) ?? .placeholder(.light)
        } set: {
            if let index = wallpapers.firstIndex(where: { $0.isFor == .light }) {
                wallpapers[index] = $0
            } else {
                wallpapers.append($0)
            }
        }
    }
    var darkWallpaper: Binding<WallpaperImage> {
        Binding<WallpaperImage> {
            wallpapers.first(where: { $0.isFor == .dark }) ?? .placeholder(.dark)
        } set: {
            if let index = wallpapers.firstIndex(where: { $0.isFor == .dark }) {
                wallpapers[index] = $0
            } else {
                wallpapers.append($0)
            }
        }
    }
    
    var body: some View {
        GeometryReader {
            let width = $0.size.width - 20 // HStack spacing is 20
            HStack(alignment: .top, spacing: 20) {
                AppearanceCell(
                    width: width,
                    wallpaper: lightWallpaper,
                    namespace: namespace
                ) { isPrimary in
                    if isPrimary {
                        darkWallpaper.wrappedValue.isPrimary = false
                    }
                }
                
                AppearanceCell(
                    width: width,
                    wallpaper: darkWallpaper,
                    namespace: namespace
                ) { isPrimary in
                    if isPrimary {
                        lightWallpaper.wrappedValue.isPrimary = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView(wallpapers: .constant([.placeholder(), .placeholder()]), namespace: Namespace().wrappedValue)
    }
}
