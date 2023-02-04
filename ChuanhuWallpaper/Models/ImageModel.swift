//
//  ImageModel.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import Foundation
import WallpapperLib
import SwiftUI

enum WallpaperAppearance {
    case light, dark, none
}

struct WallpaperImage: Hashable, Identifiable, Equatable {
    let id = UUID()
    var fileName: String { filePath.lastPathComponent }
    var filePath: URL
    var isPrimary: Bool = false
    var isFor: WallpaperAppearance = .none
    var altitude: Double? = .zero
    var azimuth: Double? = .zero
    var time: Date = Date()
    var isValid = true
    
    static func placeholder(_ isFor: WallpaperAppearance = .none) -> WallpaperImage {
        WallpaperImage(
            filePath: URL(string: "/Users/liyanan2004/Desktop/example.png")!,
            isFor: isFor,
            isValid: false
        )
    }
    
    var image: AnyView {
        if let nsImage = NSImage(contentsOfFile: filePath.path) {
            return AnyView(Image(nsImage: nsImage).resizable())
        } else {
            return AnyView(BlankWallpaper())
        }
    }
}

