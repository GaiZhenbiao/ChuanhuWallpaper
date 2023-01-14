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
        VStack {
            ScrollView{
                HStack {
                    Spacer()
                    Image(nsImage: NSImage(contentsOfFile: wallpapers[0].fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    VStack(alignment: .leading) {
                        Text("Light Image")
                            .font(.headline)
                        //                    Text(wallpapers[0].fileName)
                        Toggle("Is Primary", isOn: self.$wallpapers[0].isPrimary)
                        FilePicker(types: [.image], allowMultiple: false) { urls in
                            let filepath = urls[0].path
                            wallpapers[0].fileName = filepath.removingPercentEncoding!
                            currentSelectedNum += 1
                        } label: {
                            Label("Change Picture", systemImage: "doc.badge.plus")
                        }
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image(nsImage: NSImage(contentsOfFile: wallpapers[1].fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Form {
                        Text("Dark Image")
                            .font(.headline)
                        Toggle("Is Primary", isOn: self.$wallpapers[1].isPrimary)
                        FilePicker(types: [.image], allowMultiple: false) { urls in
                            let filepath = urls[0].path
                            wallpapers[1].fileName = filepath
                            currentSelectedNum += 1
                        } label: {
                            Label("Change Picture", systemImage: "doc.badge.plus")
                        }
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItemGroup {
                SubmitButton(wallpapers: wallpapers, disableSubmit: currentSelectedNum < 2)
            }
        }
    }
}

struct AppearanceWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceWallpaperView(wallpapers: [WallpaperImage(fileName: "noimage.jpg", isFor: .light), WallpaperImage(fileName: "noimage.jpg", isFor: .dark)])
    }
}
