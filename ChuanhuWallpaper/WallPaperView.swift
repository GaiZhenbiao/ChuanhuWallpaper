//
//  WallPaperView.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/27.
//

import SwiftUI

struct WallPaperView: View {
    @Binding var wallpapers: [WallpaperImage]
    @Binding var wallpaper: WallpaperImage
    var index: Int {
        wallpapers.firstIndex(of: wallpaper) ?? -1
    }
    
    var type: WallPaperType
    enum WallPaperType {
        case time
        case solar
    }
    
    var body: some View {
        HStack {
            Image(nsImage: NSImage(contentsOfFile: wallpaper.fileName) ?? NSImage(imageLiteralResourceName: "noimage.jpg"))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.trailing)
            VStack {
                Toggle("Is Primary", isOn: $wallpaper.isPrimary)
                Picker("Is For:", selection: $wallpaper.isFor) {
                    Text("Dark").tag(WallpaperAppearance.dark)
                    Text("Light").tag(WallpaperAppearance.light)
                    Text("None").tag(WallpaperAppearance.none)
                }
                switch type {
                case .solar:
                    TextField("Altitude", value: $wallpaper.altitude, formatter: NumberFormatter())
                    TextField("Azimuth", value: $wallpaper.azimuth, formatter: NumberFormatter())
                case .time:
                    DatePicker("Time", selection: $wallpaper.time)
                }
                buttons
            }
            .frame(maxWidth: 300)
        }
    }
    
    @ViewBuilder
    var buttons: some View {
        if index >= 0 {
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
