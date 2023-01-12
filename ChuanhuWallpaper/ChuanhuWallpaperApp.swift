//
//  ChuanhuWallpaperApp.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/11.
//

import SwiftUI

@main
struct ChuanhuWallpaperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        }
        .defaultSize(CGSize(width: 350, height: 500))
        .commands {
                    CommandGroup(replacing: .appInfo) {
                        Button("About Chuanhu Wallpaper") {
                            NSApplication.shared.orderFrontStandardAboutPanel(
                                options: [
                                    NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                        string: "Huge thanks to @Keldos for creating this app's icon!",
                                        attributes: [
                                            NSAttributedString.Key.font: NSFont.boldSystemFont(
                                                ofSize: NSFont.smallSystemFontSize)
                                        ]
                                    ),
                                    NSApplication.AboutPanelOptionKey(
                                        rawValue: "Copyright"
                                    ): "Made by @土川虎虎虎"
                                ]
                            )
                        }
                    }
                }
    }
}
