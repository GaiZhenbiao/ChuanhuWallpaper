//
//  WallpaperDropDelegate.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/29.
//

import SwiftUI

struct WallpaperDropDelegate: DropDelegate {
    var wallpaper: WallpaperImage
    @Binding var wallpapers: [WallpaperImage]
    @Binding var draggingWallpaper: WallpaperImage?
    @Binding var moveOn: WallpaperImage?
    
    func performDrop(info: DropInfo) -> Bool {
        defer {
            moveOn = nil
            draggingWallpaper = nil
        }
        if let draggingWallpaper {
            guard draggingWallpaper.id != wallpaper.id else { return false }
            let fromIndex = wallpapers.firstIndex(of: draggingWallpaper)
            if let fromIndex {
                let toIndex = wallpapers.firstIndex(of: wallpaper)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.wallpapers.swapAt(fromIndex, toIndex)
                    }
                }
            }
        } else {
            for provider in info.itemProviders(for: [.image]) {
                provider.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                    if let url {
                        guard !url.lastPathComponent.hasSuffix(".tmp") else { return }
                        guard !wallpapers.contains(where: { $0.filePath == url }) else { return }
                        guard let index = wallpapers.firstIndex(of: wallpaper) else { return }
                        let wallpaper = WallpaperImage(filePath: url)
                        withAnimation {
                            wallpapers.insert(wallpaper, at: index)
                        }
                    }
                }
            }
        }
    
        return true
    }
    
    func dropEntered(info: DropInfo) {
        moveOn = wallpaper
    }
    
    func dropExited(info: DropInfo) {
        if moveOn == wallpaper {
            moveOn = nil
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}
