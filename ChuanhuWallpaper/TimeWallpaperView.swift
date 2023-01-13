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
                    Label("Add New Picture", systemImage: "doc.badge.plus")
                }
                SubmitButton(wallpapers: wallpapers, disableSubmit: wallpapers.count < 2)
                HelpButton {
                    self.showPopover.toggle()
                }
                .popover(isPresented: self.$showPopover, arrowEdge: .bottom) {
                    VStack {
                        Text("Pictures switch based on OS time. If set to primary, the image will be visible after creating the heic file. If set to \"is for Light\", picture will be displayed when user chose \"Light (static)\". The same is true for \"is for Dark\". Time is most relevant in hour.")
                    }
                    .frame(width: 200)
                    .padding()
                }
            }
            Text("\(wallpapers.count) image(s)")
                .padding(.bottom)
        }
    }
}

struct TimeWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        TimeWallpaperView(wallpapers: [WallpaperImage(fileName: "/Users/treediagram/Downloads/appletv.jpeg")])
    }
}
