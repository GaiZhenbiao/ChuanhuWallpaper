//
//  WallpaperCell.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI

struct WallpaperCell: View {
    @Binding var wallpaper: WallpaperImage
    var type: WallPaperType
    @State private var showEditPopover = false
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            wallpaper.image
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(10)
            Text(wallpaper.fileName)
                .font(.title3)
            
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    if type == .time {
                        Text(wallpaper.time, style: .time)
                    } else {
                        if let azimuth = wallpaper.azimuth,
                           azimuth.isNormal {
                            Text("Azimuth: \(String(format: "%.2f", azimuth))")
                        }
                        
                        if let altitude = wallpaper.altitude,
                           altitude.isNormal {
                            Text("Altitude: \(String(format: "%.2f", altitude))")
                        }
                    }
                }
                HStack(spacing: 20) {
                    if wallpaper.isFor == .light {
                        Image(systemName: "sun.max")
                    } else if wallpaper.isFor == .dark {
                        Image(systemName: "moon")
                    }
                    if wallpaper.isPrimary {
                        Image(systemName: "photo")
                    }
                }
            }
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: 200, maxHeight: .infinity)
        .padding()
        .background(
            Color.secondary
                .opacity(0.05)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.2))
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showEditPopover = true
        }
        .popover(isPresented: $showEditPopover, arrowEdge: .bottom) {
            Form {
                switch type {
                case .solar:
                    TextField("Altitude", value: $wallpaper.altitude, formatter: formatter)
                    TextField("Azimuth", value: $wallpaper.azimuth, formatter: formatter)
                case .time:
                    DatePicker("Time", selection: $wallpaper.time)
                }
            }
            .frame(width: 200)
            .padding()
        }
    }
}

struct WallpaperCell_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperCell(wallpaper: .constant(.noImage), type: .solar)
    }
}
