//
//  AppearanceCell.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/2/4.
//

import SwiftUI

struct AppearanceCell: View {
    var width: CGFloat
    @Binding var wallpaper: WallpaperImage
    @State private var image = Image(systemName: "exclamationmark.square.fill")
    var namespace: Namespace.ID
    var onChangeOfThumbnail: (Bool) -> Void
    
    @State private var isTargeted = false
    
    var body: some View {
        VStack(alignment: .leading) {
            header.font(.title.bold())
            Group {
                if wallpaper.isValid {
                    image
                        .resizable()
                        .matchedGeometryEffect(id: wallpaper.id, in: namespace)
                        .aspectRatio(contentMode: .fill)
                        .onAppear {
                            if let nsImage = NSImage(contentsOfFile: wallpaper.filePath.path) {
                                image = Image(nsImage: nsImage)
                            }
                        }
                        .onChange(of: wallpaper.filePath) { newValue in
                            if let nsImage = NSImage(contentsOfFile: newValue.path) {
                                image = Image(nsImage: nsImage)
                            }
                        }
                } else {
                    WallpaperPlaceholderCell(compact: false, allowMultiple: false, isDropTarget: isTargeted) { url in
                        addWallpaper(url: url)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: min(300, width / 2))
            .mask(
                RoundedRectangle(cornerRadius: 10)
                    .matchedGeometryEffect(id: "\(wallpaper.id) mask", in: namespace)
            )
            .onDrop(of: [.image, .png, .jpeg], isTargeted: $isTargeted) { providers in
                providers.first?.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                    if let url {
                        addWallpaper(url: url)
                    }
                }
                return true
            }
            Toggle("Is Primary", isOn: $wallpaper.isPrimary)
                .onChange(of: wallpaper.isPrimary, perform: onChangeOfThumbnail)
        }
        .matchedGeometryEffect(id: "\(wallpaper.id) container", in: namespace)
    }
    
    @ViewBuilder
    private var header: some View {
        if wallpaper.isFor == .light {
            Text("Light")
        } else {
            Text("Dark")
        }
    }
    
    private func addWallpaper(url: URL) {
        var wallpaper = WallpaperImage(filePath: url)
        wallpaper.isFor = self.wallpaper.isFor
        self.wallpaper = wallpaper
    }
}
