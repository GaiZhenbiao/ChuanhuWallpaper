//
//  UsefulFunctions.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/12.
//

import Foundation
import SwiftUI

func showSavePanel() -> String? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.heic]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save your image"
    savePanel.message = "Choose a folder and a name to store the image."
    savePanel.nameFieldLabel = "Image file name:"

    let response = savePanel.runModal()
    return response == .OK ? savePanel.url?.path().removingPercentEncoding : nil
}

func loadImageFromDiskWith(fileName: String) -> NSImage? {

  let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = NSImage(contentsOfFile: imageUrl.path)
        return image

    }

    return nil
}
