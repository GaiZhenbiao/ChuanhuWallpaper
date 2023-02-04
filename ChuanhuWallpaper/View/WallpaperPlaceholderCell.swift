//
//  WallpaperPlaceholderCell.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI
import FilePicker

struct WallpaperPlaceholderCell: View {
    var compact: Bool
    var allowMultiple: Bool = true
    var isDropTarget: Bool = false
    var addWallpaper: (URL) -> Void
    
    var body: some View {
        ZStack {
            if compact {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .imageScale(.large)
                        .font(.largeTitle)
                    HStack {
                        Text("Drag images here")
                        Text("OR")
                        fileImportButton
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary)
                    .opacity(0.05)
                if isDropTarget {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 3)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.1), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [12]))
                }
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .imageScale(.large)
                        .font(.largeTitle)
                    VStack {
                        Text("Drag images here")
                        Text("OR")
                        fileImportButton
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.secondary)
    }
    
    private var fileImportButton: some View {
        FilePicker(types: [.image], allowMultiple: allowMultiple) { urls in
            for url in urls {
                addWallpaper(url)
            }
        } label: {
            Text("Choose Photo(s)...").fixedSize(horizontal: false, vertical: true)
        }
        .keyboardShortcut("i")
    }
}

struct WallpaperPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperPlaceholderCell(compact: false) { urls in
            print(urls)
        }
    }
}
