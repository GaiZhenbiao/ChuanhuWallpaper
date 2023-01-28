////
////  SolarWallpaperView.swift
////  ChuanhuWallpaper
////
////  Created by Tree Diagram on 2023/1/11.
////
//
//import SwiftUI
//import FilePicker
//import WallpapperLib
//
//struct SolarWallpaperView: View {
//    @State var wallpapers: [WallpaperImage] = []
//    @State var showErrorMessage = false
//    @State var errorMessage = ""
//    @State private var dropTarget = false
//    let wallpaperGenerator = WallpaperGenerator()
//    
//    var body: some View {
//        Group {
//            if wallpapers.isEmpty {
//                noWallpapers
//            } else {
//                wallpapersList
//            }
//        }
//        .overlay(dropPlaceholder)

//        .toolbar(content: toolbar)
//        .navigationSubtitle(String(wallpapers.count) + " image(s)")
//    }
//    
//    var noWallpapers: some View {
//        Text("No images yet.")
//            .font(.title2.bold())
//            .foregroundColor(.secondary)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//    
//    var wallpapersList: some View {
//        ScrollView {
//            VStack {
//                ForEach($wallpapers, id: \.id) { wallpaper in
//                    WallPaperView(wallpapers: $wallpapers, wallpaper: wallpaper, type: .solar)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .padding()
//        }
//    }
//    
//    @ViewBuilder
//    var dropPlaceholder: some View {
//        if dropTarget {
//            Rectangle()
//                .stroke(Color.secondary, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [10], dashPhase: 0))
//                .padding(5)
//        }
//    }
//}
//
//extension SolarWallpaperView {
//    @ToolbarContentBuilder
//    func toolbar() -> some ToolbarContent {
//        ToolbarItemGroup {
//            HelpButton {
//                Text("The primary image will be visible after creating heic file. \nIf image was set to Light, it will be displayed when user chose \"Light (static)\" wallpaper. The same happened when set to Dark. \nAltitude is the angle between the Sun and the observer's local horizon. Azimuth  is the angle of the Sun around the horizon.")
//                    .frame(width: 200)
//            }
//            
//            FilePicker(types: [.image], allowMultiple: true) { urls in
//                for url in urls {
//                    if addWallpaper(at: url) == false {
//                        // Failed to add wallpaper / one of the wallpapers.
//                        // Discard all the wallpapers after that.
//                        return
//                    }
//                }
//            } label: {
//                ZStack {
//                    Image(systemName: "photo.on.rectangle")
//                    Image(systemName: "plus.circle.fill")
//                        .font(.system(size: 8))
//                        .offset(x:8,y:-5)
//                }
//                Text("Add New Picture")
//                //Label("Add New Picture", systemImage: "doc.badge.plus")
//            }
//            SaveButton(wallpapers: wallpapers).disabled(wallpapers.count < 2)
//        }
//    }
//    

//}
//
//struct SolarWallpaperView_Previews: PreviewProvider {
//    static var previews: some View {
//        SolarWallpaperView(wallpapers: [WallpaperImage(fileName: "/Users/treediagram/Downloads/appletv.jpeg")])
//    }
//}
