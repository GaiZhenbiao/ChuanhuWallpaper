//
//  SaveButton.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/13.
//

import SwiftUI
import WallpapperLib

struct SaveButton: View {
    var wallpapers: [WallpaperImage]
    var mode: WallpaperMode
    @State var showErrorMessage = false
    @State var errorMessage = ""
    let wallpaperGenerator = WallpaperGenerator()
    
    var body: some View {
        Button(action: save) {
            Label("Save...", systemImage: "square.and.arrow.down")
        }
        .buttonStyle(.standard)
        .disabled(wallpapers.count < 2)
        .alert(isPresented: $showErrorMessage) {
            Alert(title: Text("An Error Occured"), message: Text(errorMessage), dismissButton: .cancel())
        }
        .keyboardShortcut("s")
        .help("⌘ S")
    }
    
    private func save() {
        var pictureInfos: [PictureInfo] = []
        for wallpaper in wallpapers {
            // Skip wallpapers which are not for light or dark mode when current mode is appearance.
            if mode == .appearance && wallpaper.isFor == .none {
                continue
            }
            let info = PictureInfo(fileName: wallpaper.filePath.path, isPrimary: wallpaper.isPrimary, isForLight: wallpaper.isFor == .light, isForDark: wallpaper.isFor == .dark, altitude: wallpaper.altitude, azimuth: wallpaper.azimuth)
            pictureInfos.append(info)
        }
        if let outputFileName = showSavePanel() {
            let infos = pictureInfos
            Task {
                do {
                    try wallpaperGenerator.generate(pictureInfos: infos, baseURL: URL(string: "/")!, outputFileName: outputFileName.path)
                } catch (let error as WallpapperError) {
                    showErrorMessage = true
                    errorMessage = "Unexpected error occurs: \(error.message)"
                } catch {
                    showErrorMessage = true
                    errorMessage = "Really Unexpected error occurs: \(error)"
                }
            }
        }
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveButton(wallpapers: [], mode: .appearance)
    }
}
