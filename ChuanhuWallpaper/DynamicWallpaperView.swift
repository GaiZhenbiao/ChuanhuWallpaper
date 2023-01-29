//
//  DynamicWallpaperView.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI
import WallpapperLib
import FilePicker

struct DynamicWallpaperView: View {
    @Binding var wallpapers: [WallpaperImage]
    @Binding var selectedWallpaper: WallpaperImage?
    @State private var isDropTarget = false
    var namespace: Namespace.ID
    @Binding var type: WallPaperType
    
    var body: some View {
        Group {
            if wallpapers.isEmpty {
                placeholder(compact: false)
            } else {
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 200), spacing: 20)],
                            spacing: 20
                        ) {
                            ForEach($wallpapers) { wallpaper in
                                WallpaperCell(wallpaper: wallpaper, type: type)
                                .contextMenu { contextButtons(wallpaper: wallpaper) }
                            }
                        }
                        
                        placeholder(compact: true)
                            .frame(maxHeight: .infinity)
                    }
                    .padding()
                }
            }
        }
        .onDrop(of: [.jpeg, .image, .png], isTargeted: $isDropTarget) { providers in
            importFromProviders(providers)
            return true
        }
    }
    
    @ViewBuilder
    func contextButtons(wallpaper: Binding<WallpaperImage>) -> some View {
        if !wallpaper.wrappedValue.isPrimary {
            Button("Is Primary") {
                if let index = wallpapers.firstIndex(where: { $0.isPrimary }) {
                    wallpapers[index].isPrimary = false
                }
                wallpaper.wrappedValue.isPrimary = true
            }
        }
        
        Divider()
        
        Button("For Light Mode") {
            if let index = wallpapers.firstIndex(where: { $0.isFor == .light }) {
                wallpapers[index].isFor = .none
            }
            wallpaper.wrappedValue.isFor = .light
        }
        .disabled(wallpaper.wrappedValue.isFor == .light)
        
        Button("For Dark Mode") {
            if let index = wallpapers.firstIndex(where: { $0.isFor == .dark }) {
                wallpapers[index].isFor = .none
            }
            wallpaper.wrappedValue.isFor = .dark
        }
        .disabled(wallpaper.wrappedValue.isFor == .dark)
        
        Divider()
        
        Button {
            withAnimation {
                if let index = wallpapers.firstIndex(of: wallpaper.wrappedValue) {
                    wallpapers.remove(at: index)
                }
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    func placeholder(compact: Bool) -> some View {
        WallpaperPlaceholderCell(compact: compact, isDropTarget: $isDropTarget, addWallpaper: addWallpaper(at:))
    }
    
    private func importFromProviders(_ providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                if let url {
                    addWallpaper(at: url)
                }
            }
        }
    }
    
    private func addWallpaper(at url: URL) {
        guard let inputFileContents = try? Data(contentsOf: url) else { return }
        
        let locationExtractor = LocationExtractor()
        if let imageLocation = try? locationExtractor.extract(imageData: inputFileContents) {
            let sunCalculations = SunCalculations(imageLocation: imageLocation)
            let position = sunCalculations.getSunPosition()
            let wallpaper = WallpaperImage(filePath: url, altitude: position.altitude, azimuth: position.azimuth)
            wallpapers.append(wallpaper)
        } else if let imageCreateDate = try? locationExtractor.extractTime(imageData: inputFileContents) {
            wallpapers.append(WallpaperImage(filePath: url, time: imageCreateDate))
        } else {
            wallpapers.append(WallpaperImage(filePath: url))
        }
    }
}

struct DynamicWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicWallpaperView(wallpapers: .constant([.noImage]), selectedWallpaper: .constant(nil),  namespace: Namespace().wrappedValue, type: .constant(.solar))
    }
}

extension View {
    func conditionally<V: View>(@ViewBuilder _ view: (Self) -> V) -> V {
        view(self)
    }
}

enum WallPaperType {
    case time
    case solar
}
