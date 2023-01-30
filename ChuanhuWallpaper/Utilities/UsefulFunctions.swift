//
//  UsefulFunctions.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/12.
//

import Foundation
import SwiftUI

func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.heic]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save your dynamic wallpaper"
    savePanel.message = "Choose a folder and a name to store the wallpaper."
    savePanel.nameFieldLabel = "Wallpaper file name:"

    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
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

struct HelpButton<Popover: View>: View {
    @State private var showPopover = false
    var content: () -> Popover

    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(Color(NSColor.separatorColor), lineWidth: 0.5)
                    .background(Circle().foregroundColor(Color(NSColor.controlColor)))
                    .shadow(color: Color(NSColor.separatorColor).opacity(0.3), radius: 1)
                    .frame(width: 20, height: 20)
                Text("?").font(.system(size: 15, weight: .medium))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            content().padding()
        }
    }
}
