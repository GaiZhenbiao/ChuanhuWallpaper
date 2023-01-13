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
    @State var currentSelectedNum = 0
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
                            currentSelectedNum += 1
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
                            currentSelectedNum += 1
                        }
                    } label: {
                        Label("Change Picture", systemImage: "doc.badge.plus")
                    }
                }
            }
            .padding()
            SubmitButton(wallpapers: wallpapers)
            .padding(.bottom)
        }
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView(wallpapers: [WallpaperImage(fileName: "noimage.jpg", isFor: .light), WallpaperImage(fileName: "noimage.jpg", isFor: .dark)])
    }
}
