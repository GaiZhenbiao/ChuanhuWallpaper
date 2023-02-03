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
    @State private var draggingWallpaper: WallpaperImage?
    @State private var moveOn: WallpaperImage?
    @State private var isDropTarget = false
    var namespace: Namespace.ID
    @Binding var mode: WallpaperMode
    
    var body: some View {
        Group {
            if wallpapers.isEmpty {
                placeholder(compact: false)
            } else {
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 170), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(wallpapers) { wallpaper in
                                let wallpaper = Binding<WallpaperImage> {
                                    wallpaper
                                } set: { wallpaper in
                                    if let index = wallpapers.firstIndex(where: { $0.id == wallpaper.id }) {
                                        wallpapers[index] = wallpaper
                                    }
                                }
                                ZStack {
                                    WallpaperCell(wallpaper: wallpaper, mode: mode, namespace: namespace) {
                                        contextButtons(wallpaper: wallpaper)
                                    }
                                    Group {
                                        if moveOn == wallpaper.wrappedValue {
                                            Rectangle()
                                                .fill(Color.accentColor)
                                                .frame(width: 3)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                }
                                
//                                .overlay(
//
//                                    , alignment: .leading
//                                )
                                .onDrag({
                                    draggingWallpaper = wallpaper.wrappedValue
                                    return NSItemProvider(item: Data() as NSSecureCoding, typeIdentifier: "public.image")
                                })
                                .onDrop(
                                    of: [.image],
                                    delegate: WallpaperDropDelegate(wallpaper: wallpaper.wrappedValue, wallpapers: $wallpapers, draggingWallpaper: $draggingWallpaper, moveOn: $moveOn)
                                )
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
        let isPrimary = Binding<Bool> {
            wallpaper.wrappedValue.isPrimary
        } set: { isPrimary in
            if isPrimary {
                if let index = wallpapers.firstIndex(where: { $0.isPrimary }) {
                    wallpapers[index].isPrimary = false
                }
            }
            wallpaper.wrappedValue.isPrimary = isPrimary
        }
        Toggle(isOn: isPrimary.animation()) {
            Label("Is Primary", systemImage: "photo")
        }
        
        Divider()
        
        let isFor = Binding<WallpaperAppearance> {
            wallpaper.wrappedValue.isFor
        } set: { appearance in
            if let index = wallpapers.firstIndex(where: { $0.isFor == appearance }) {
                wallpapers[index].isFor = .none
            }
            wallpaper.wrappedValue.isFor = appearance
        }
        Picker("Is For", selection: isFor.animation()) {
            Label {
                Text("Auto")
            } icon: {
                Image("appearance")
                    .renderingMode(.template)
                    .foregroundColor(.primary)
            }
            .tag(WallpaperAppearance.none)
            Label("Light", systemImage: "sun.max").tag(WallpaperAppearance.light)
            Label("Dark", systemImage: "moon").tag(WallpaperAppearance.dark)
        }
        .pickerStyle(.radioGroup)
        
        Divider()
        
        Button {
            remove(wallpaper: wallpaper.wrappedValue)
        } label: {
            Label("Delete", systemImage: "trash")
                .foregroundColor(.red)
        }
    }
    
    private func placeholder(compact: Bool) -> some View {
        WallpaperPlaceholderCell(compact: compact, isDropTarget: isDropTarget, addWallpaper: addWallpaper(at:))
            .padding()
    }
    
    private func remove(wallpaper: WallpaperImage) {
        withAnimation {
            if let index = wallpapers.firstIndex(of: wallpaper) {
                wallpapers.remove(at: index)
            }
        }
    }
    
    private func importFromProviders(_ providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                if let url {
                    guard !url.lastPathComponent.hasSuffix(".tmp") else { return }
                    guard !wallpapers.contains(where: { $0.filePath == url }) else { return }
                    withAnimation {
                        addWallpaper(at: url)
                    }
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
        DynamicWallpaperView(wallpapers: .constant([.placeholder()]), namespace: Namespace().wrappedValue, mode: .constant(.solar))
    }
}

extension View {
    func conditionally<V: View>(@ViewBuilder _ view: (Self) -> V) -> V {
        view(self)
    }
}

enum WallpaperMode {
    case time
    case solar
    case appearance
}
