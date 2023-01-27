//
//  AppearanceWallpaperView.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import SwiftUI
import FilePicker
import WallpapperLib

struct AppearanceWallpaperView: View {
    @State private var lightWallpaper = WallpaperImage(fileName: "noimage.jpg", isFor: .light)
    @State private var darkWallpaper = WallpaperImage(fileName: "noimage.jpg", isFor: .dark)
    @State var pictureInfos: [PictureInfo] = []
    @State var showErrorMessage = false
    @State var errorMessage = ""
    @State var currentSelectedNum = 0
    let wallpaperGenerator = WallpaperGenerator()
    
    var body: some View {
        VStack {
            light
            dark
        }
        .toolbar {
            let wallpapers = [lightWallpaper, darkWallpaper]
            SubmitButton(wallpapers: wallpapers).disabled(currentSelectedNum < 2)
        }
    }
    
    var light: some View {
        HStack {
            Image(nsImage: NSImage(contentsOfFile: lightWallpaper.fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            VStack(alignment: .leading) {
                Text("Light Image")
                    .font(.headline)
                Toggle("Is Primary", isOn: self.$lightWallpaper.isPrimary)
                FilePicker(types: [.image], allowMultiple: false) { urls in
                    let filepath = urls[0].path
                    lightWallpaper.fileName = filepath.removingPercentEncoding!
                    currentSelectedNum += 1
                } label: {
                    Label("Change Picture", systemImage: "doc.badge.plus")
                }
            }
        }
        .onDrop(of: [.image, .jpeg, .png], isTargeted: .constant(false)) { providers in
            providers[0].loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                if let url {
                    lightWallpaper.fileName = url.path
                    currentSelectedNum += 1
                }
            }
            return true
        }
    }
    
    var dark: some View {
        HStack {
            Image(nsImage: NSImage(contentsOfFile: darkWallpaper.fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Form {
                Text("Dark Image")
                    .font(.headline)
                Toggle("Is Primary", isOn: self.$darkWallpaper.isPrimary)
                FilePicker(types: [.image], allowMultiple: false) { urls in
                    let filepath = urls[0].path
                    darkWallpaper.fileName = filepath
                    currentSelectedNum += 1
                } label: {
                    Label("Change Picture", systemImage: "doc.badge.plus")
                }
            }
        }
        .onDrop(of: [.image, .jpeg, .png], isTargeted: .constant(false)) { providers in
            providers[0].loadInPlaceFileRepresentation(forTypeIdentifier: "public.image") { url, _, _ in
                if let url {
                    darkWallpaper.fileName = url.path
                    currentSelectedNum += 1
                }
            }
            return true
        }
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView()
    }
}
