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
    @State var wallpapers: [WallpaperImage] = [WallpaperImage(fileName: "noimage.jpg", isFor: .light), WallpaperImage(fileName: "noimage.jpg", isFor: .dark)]
    @State var pictureInfos: [PictureInfo] = []
    @State var showErrorMessage = false
    @State var errorMessage = ""
    let wallpaperGenerator = WallpaperGenerator()
    
    var body: some View {
        ScrollView{
            HStack {
                Image(nsImage: NSImage(contentsOfFile: wallpapers[0].fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack(alignment: .leading) {
                    Text("Light Image")
                        .font(.headline)
                    Toggle("Is Primary", isOn: self.$wallpapers[0].isPrimary)
                    FilePicker(types: [.image], allowMultiple: false) { urls in
                        if let filepath = urls[0].path().removingPercentEncoding{
                            wallpapers[0].fileName = filepath
                        }
                    } label: {
                        Label("Change Picture", systemImage: "doc.badge.plus")
                    }
                }
            }
            HStack {
                Image(nsImage: NSImage(contentsOfFile: wallpapers[1].fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Form {
                    Text("Dark Image")
                        .font(.headline)
                    Toggle("Is Primary", isOn: self.$wallpapers[1].isPrimary)
                    FilePicker(types: [.image], allowMultiple: false) { urls in
                        if let filepath = urls[0].path().removingPercentEncoding{
                            wallpapers[1].fileName = filepath
                        }
                    } label: {
                        Label("Change Picture", systemImage: "doc.badge.plus")
                    }
                }
            }
            .padding()
            Button {
                pictureInfos = []
                for wallpaper in wallpapers{
                    pictureInfos.append(PictureInfo( fileName: wallpaper.fileName, isPrimary: wallpaper.isPrimary, isForLight: wallpaper.isFor == .light, isForDark: wallpaper.isFor == .dark))
                }
                if let outputFileName = showSavePanel(){
                    do {
                        try wallpaperGenerator.generate(pictureInfos: pictureInfos, baseURL: URL(string: "/")!, outputFileName: outputFileName)
                    } catch (let error as WallpapperError) {
                        showErrorMessage = true
                        errorMessage = "Unexpected error occurs: \(error.message)"
                    } catch {
                        showErrorMessage = true
                        errorMessage = "Really Unexpected error occurs: \(error)"
                    }
                }
            } label: {
                Label {
                    Text("Save Wallpaper")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .alert(isPresented: $showErrorMessage) {
                Alert(title: Text("An Error Occured"), message: Text(errorMessage), dismissButton: .cancel())
            }
        }
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView(wallpapers: [WallpaperImage(fileName: "noimage.jpg", isFor: .light), WallpaperImage(fileName: "noimage.jpg", isFor: .dark)])
    }
}
