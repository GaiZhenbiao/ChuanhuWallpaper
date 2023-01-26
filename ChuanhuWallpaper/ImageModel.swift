//
//  ImageModel.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import Foundation
import WallpapperLib

enum WallpaperAppearance {
    case light, dark, none
}

struct WallpaperImage: Hashable, Identifiable, Equatable {
    let id = UUID()
    var fileName: String
    var isPrimary: Bool = false
    var isFor: WallpaperAppearance = .none
    var altitude: Double = 0.0
    var azimuth: Double = 0.0
    var time: Date = Date()
}
