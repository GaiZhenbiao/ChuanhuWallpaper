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
    @State var showPopover = false
    let wallpaperGenerator = WallpaperGenerator()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if(wallpapers.count == 0){
                        Spacer()
                        Text("No images yet.")
                            .foregroundColor(.secondary)
                    }
                    ForEach(wallpapers.indices, id: \.self) { index in
                        let wallpaper = Binding<WallpaperImage> {
                            wallpapers[index]
                        } set: {
                            wallpapers[min(index, wallpapers.count - 1)] = $0
                        }
                        let wrappedWallpaper = wallpaper.wrappedValue
                        HStack {
                            Image(nsImage: NSImage(contentsOfFile: wrappedWallpaper.fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.trailing)
                            Form {
                                Toggle("Is Primary", isOn: wallpaper.isPrimary)
                                Picker("Is For:", selection: wallpaper.isFor) {
                                    Text("Dark").tag(WallpaperAppearance.dark)
                                    Text("Light").tag(WallpaperAppearance.light)
                                    Text("None").tag(WallpaperAppearance.none)
                                }
                                DatePicker(selection: wallpaper.time, label: { Text("Time") })
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
                            .frame(maxWidth: 300)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding(.bottom)
            }
        }
        .toolbar {
            ToolbarItemGroup {
                HelpButton {
                    self.showPopover.toggle()
                }
                .popover(isPresented: self.$showPopover, arrowEdge: .bottom) {
                    VStack {
                        Text("Pictures switch based on OS time. \nIf set to primary, the image will be visible after creating the heic file. \nIf set to \"is for Light\", picture will be displayed when user chose \"Light (static)\". The same is true for \"is for Dark\". \nTime is most relevant in hour.")
                    }
                    .frame(width: 200)
                    .padding()
                }
                FilePicker(types: [.image], allowMultiple: false) { urls in
                    //                    if let filepath = urls[0].path().removingPercentEncoding{
                    //                        wallpapers.append(WallpaperImage(fileName: filepath))
                    //                    }
                    let fileURL = urls[0]
                    do {
                        let inputFileContents = try Data(contentsOf: fileURL)
                        let locationExtractor = LocationExtractor()
                        let imageCreateDate = try locationExtractor.extractTime(imageData: inputFileContents)
                        wallpapers.append(WallpaperImage(fileName: fileURL.path, time: imageCreateDate))
                    } catch (let error) where "\(error)" == "missingCreationDate" {
                        wallpapers.append(WallpaperImage(fileName: fileURL.path))
                    } catch (let error as WallpapperError) {
                        showErrorMessage = true
                        errorMessage = "Unexpected error occurs: \(error)"
                    } catch {
                        showErrorMessage = true
                        errorMessage = "oops: \(error)"
                    }
                } label: {
                    ZStack {
                        Image(systemName: "photo.on.rectangle")
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 8))
                            .offset(x:8,y:-5)
                    }
                    Text("Add New Picture")
                    //Label("Add New Picture", systemImage: "doc.badge.plus")
                }
                SubmitButton(wallpapers: wallpapers, disableSubmit: wallpapers.count < 2)
            }
        }
        .navigationSubtitle("\(wallpapers.count) image(s)")
    }
}

struct TimeWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        TimeWallpaperView(wallpapers: [WallpaperImage(fileName: "/Users/treediagram/Downloads/appletv.jpeg")])
    }
}
