//
//  SolarWallpaperView.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import SwiftUI
import FilePicker
import WallpapperLib

struct SolarWallpaperView: View {
    @State var wallpapers: [WallpaperImage] = []
    @State var showErrorMessage = false
    @State var errorMessage = ""
    @State var showPopover = false
    var numbers: [Int] {
        let numbers: [Int] = Array(0..<wallpapers.count)
        return numbers
    }
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
                    ForEach(numbers, id: \.self) { index in
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
                                TextField("Altitude", value: self.$wallpapers[index].altitude, formatter: NumberFormatter())
                                TextField("Azimuth", value: self.$wallpapers[index].azimuth, formatter: NumberFormatter())
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
                        Text("The primary image will be visible after creating heic file. \nIf image was set to Light, it will be displayed when user chose \"Light (static)\" wallpaper. The same happened when set to Dark. \nAltitude is the angle between the Sun and the observer's local horizon. Azimuth  is the angle of the Sun around the horizon.")
                    }
                    .frame(width: 200)
                    .padding()
                }
                FilePicker(types: [.image], allowMultiple: false) { urls in
                    let fileURL = urls[0]
                    do {
                        let inputFileContents = try Data(contentsOf: fileURL)
                        let locationExtractor = LocationExtractor()
                        let imageLocation = try locationExtractor.extract(imageData: inputFileContents)
                        let sunCalculations = SunCalculations(imageLocation: imageLocation)
                        let position = sunCalculations.getSunPosition()
                        wallpapers.append(WallpaperImage(fileName: fileURL.path, altitude: position.altitude, azimuth: position.azimuth))
                    } catch (let error) where "\(error)" == "missingLatitude" {
                        wallpapers.append(WallpaperImage(fileName: fileURL.path))
                    } catch (let error as WallpapperError) {
                        showErrorMessage = true
                        errorMessage = "Unexpected error occurs: \(error.message)"
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
        .navigationSubtitle(String(wallpapers.count) + " image(s)")
    }
}

struct SolarWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        SolarWallpaperView(wallpapers: [WallpaperImage(fileName: "/Users/treediagram/Downloads/appletv.jpeg")])
    }
}
