//
//  WallpaperPicker.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI

struct WallpaperPicker<Label: View>: View {
    var wallpapers: [WallpaperImage]
    @Binding var selection: WallpaperImage?
    @ViewBuilder var label: () -> Label
    @State private var onHover = false
    @State private var showPopover = false
    
    var body: some View {
        HStack(spacing: 10) {
            label().font(.headline.bold())
            
            HStack {
                if let selection {
                    selection.image
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 52, height: 52)
                        .cornerRadius(3)
                }
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: 32)
        .contentShape(Rectangle())
        .onTapGesture {
            showPopover = true
        }
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            Form {
                ForEach(wallpapers) { wallpaper in
                    HStack {
                        wallpaper.image
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 52, height: 52)
                            .cornerRadius(5)
                        Text(wallpaper.fileName)
                    }
                    .onTapGesture {
                        selection = wallpaper
                        showPopover = false
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        Group {
                            if wallpaper == selection {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .imageScale(.large)
                            }
                        }
                        , alignment: .trailing
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .frame(width: 230)
        }
    }
}

struct WallpaperPicker_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperPicker(wallpapers: [.placeholder(), .placeholder()], selection: .constant(.placeholder())) {
            Text("Light Mode")
        }
    }
}
