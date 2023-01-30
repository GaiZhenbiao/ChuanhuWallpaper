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
    
    @State private var lightModeImage = Image(systemName: "exclamationmark.square.fill")
    @State private var darkModeImage = Image(systemName: "exclamationmark.square.fill")
    
    @State private var lightTargeted = false
    @State private var darkTargeted = false
    
    var lightWallpaper: Binding<WallpaperImage> {
        Binding<WallpaperImage> {
            wallpapers.first(where: { $0.isFor == .light }) ?? .placeholder()
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
            wallpapers.first(where: { $0.isFor == .dark }) ?? .placeholder()
        } set: {
            if let index = wallpapers.firstIndex(where: { $0.isFor == .dark }) {
                wallpapers[index] = $0
            } else {
                wallpapers.append($0)
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Light").font(.largeTitle.bold())
                Group {
                    if lightWallpaper.wrappedValue.isValid {
                        lightModeImage
                            .resizable()
                            .matchedGeometryEffect(id: lightWallpaper.wrappedValue.id, in: namespace)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 300)
                            .onAppear {
                                if let nsImage = NSImage(contentsOfFile: lightWallpaper.wrappedValue.filePath.path) {
                                    lightModeImage = Image(nsImage: nsImage)
                                }
                            }
                            .onChange(of: lightWallpaper.wrappedValue.filePath) { newValue in
                                if let nsImage = NSImage(contentsOfFile: newValue.path) {
                                    lightModeImage = Image(nsImage: nsImage)
                                }
                            }
                    } else {
                        WallpaperPlaceholderCell(compact: false, allowMultiple: false, isDropTarget: lightTargeted) { url in
                            addWallpaper(url: url, for: .light)
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 300)
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                        .matchedGeometryEffect(id: "\(lightWallpaper.wrappedValue.id) mask", in: namespace)
                )
                .onDrop(of: [.image, .png, .jpeg], isTargeted: $lightTargeted) { providers in
                    providers.first?.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                        if let url {
                            addWallpaper(url: url, for: .light)
                        }
                    }
                    return true
                }
                Toggle("Is Primary", isOn: lightWallpaper.isPrimary)
                    .onChange(of: lightWallpaper.wrappedValue.isPrimary) { newValue in
                        if newValue {
                            darkWallpaper.wrappedValue.isPrimary = false
                        }
                    }
            }
            .matchedGeometryEffect(id: "\(lightWallpaper.wrappedValue.id) container", in: namespace)
            
            VStack(alignment: .leading) {
                Text("Dark").font(.largeTitle.bold())
                Group {
                    if darkWallpaper.wrappedValue.isValid {
                        darkModeImage
                            .resizable()
                            .matchedGeometryEffect(id: darkWallpaper.wrappedValue.id, in: namespace)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 300)
                            .onAppear {
                                if let nsImage = NSImage(contentsOfFile: darkWallpaper.wrappedValue.filePath.path) {
                                    darkModeImage = Image(nsImage: nsImage)
                                }
                            }
                            .onChange(of: darkWallpaper.wrappedValue.filePath) { newValue in
                                if let nsImage = NSImage(contentsOfFile: newValue.path) {
                                    darkModeImage = Image(nsImage: nsImage)
                                }
                            }
                    } else {
                        WallpaperPlaceholderCell(compact: false, allowMultiple: false, isDropTarget: darkTargeted) { url in
                            addWallpaper(url: url, for: .dark)
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 300)
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                        .matchedGeometryEffect(id: "\(darkWallpaper.wrappedValue.id) mask", in: namespace)
                )
                .onDrop(of: [.image, .png, .jpeg], isTargeted: $darkTargeted) { providers in
                    providers.first?.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                        if let url {
                            addWallpaper(url: url, for: .dark)
                        }
                    }
                    return true
                }
               
                Toggle("Is Primary", isOn: darkWallpaper.isPrimary)
                    .onChange(of: darkWallpaper.wrappedValue.isPrimary) { newValue in
                        if newValue {
                            lightWallpaper.wrappedValue.isPrimary = false
                        }
                    }
            }
            .matchedGeometryEffect(id: "\(darkWallpaper.wrappedValue.id) container", in: namespace)
        }
        .padding()
    }
    
    private func addWallpaper(url: URL, for appearance: WallpaperAppearance) {
        var wallpaper = WallpaperImage(filePath: url)
        if appearance == .light {
            wallpaper.isFor = .light
            lightWallpaper.wrappedValue = wallpaper
        } else if appearance == .dark {
            wallpaper.isFor = .dark
            darkWallpaper.wrappedValue = wallpaper
        }
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView(wallpapers: .constant([.placeholder(), .placeholder()]), namespace: Namespace().wrappedValue)
    }
}
