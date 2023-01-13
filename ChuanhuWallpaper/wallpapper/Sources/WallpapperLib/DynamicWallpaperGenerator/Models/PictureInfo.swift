//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public struct PictureInfo {
    var fileName: String
    var isPrimary: Bool?
    var isForLight: Bool?
    var isForDark: Bool?
    var altitude: Double?
    var azimuth: Double?
    var time: Date?
    
    public init(fileName: String, isPrimary: Bool? = nil, isForLight: Bool? = nil, isForDark: Bool? = nil, altitude: Double? = nil, azimuth: Double? = nil, time: Date? = nil) {
        self.fileName = fileName
        self.isPrimary = isPrimary
        self.isForLight = isForLight
        self.isForDark = isForDark
        self.altitude = altitude
        self.azimuth = azimuth
        self.time = time
    }
}
