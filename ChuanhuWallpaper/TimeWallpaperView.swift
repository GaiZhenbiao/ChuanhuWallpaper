//
//  TimeWallpaperView.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import SwiftUI
import FilePicker
import WallpapperLib

struct TimeWallpaperView: View {
    @State var wallpapers: [WallpaperImage] = []
    @State var pictureInfos: [PictureInfo] = []
    @State var showErrorMessage = false
    @State var errorMessage = ""
    let wallpaperGenerator = WallpaperGenerator()
    
    var body: some View {
        ScrollView{
            HStack {
                VStack {
                    ForEach(0..<wallpapers.count, id: \.self) { index in
                        HStack {
                            Image(nsImage: NSImage(contentsOfFile: wallpapers[index].fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.trailing)
                            Form {
                                Toggle("Is Primary", isOn: self.$wallpapers[index].isPrimary)
                                Picker("Is For:", selection: self.$wallpapers[index].isFor) {
                                    Text("Dark").tag(WallpaperAppearance.dark)
                                    Text("Light").tag(WallpaperAppearance.light)
                                    Text("None").tag(WallpaperAppearance.none)
                                }
                                DatePicker(selection: self.$wallpapers[index].time, label: { Text("Time") })
                                HStack {
                                    Spacer()
                                    Button {
                                        wallpapers.swapAt(index, index-1)
                                    } label: {
                                        Text("Move Up")
                                    }
                                    .disabled(index == 0)
                                    Button {
                                        wallpapers.swapAt(index, index+1)
                                    } label: {
                                        Text("Move Down")
                                    }
                                    .disabled(index == wallpapers.count-1)
                                    Button {
                                        wallpapers.remove(at: index)
                                    } label: {
                                        Text("Trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            HStack {
                FilePicker(types: [.image], allowMultiple: false) { urls in
                    if let filepath = urls[0].path().removingPercentEncoding{
                        wallpapers.append(WallpaperImage(fileName: filepath))
                    }
                } label: {
                    Label("Add New Picture", systemImage: "doc.badge.plus")
                }
                Button {
                    pictureInfos = []
                    for wallpaper in wallpapers{
                        pictureInfos.append(PictureInfo( fileName: wallpaper.fileName, isPrimary: wallpaper.isPrimary, isForLight: wallpaper.isFor == .light, isForDark: wallpaper.isFor == .dark, time: wallpaper.time))
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
            Text("\(wallpapers.count) image(s)")
        }
    }
}

struct TimeWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        TimeWallpaperView(wallpapers: [WallpaperImage(fileName: "/Users/treediagram/Downloads/appletv.jpeg")])
    }
}
