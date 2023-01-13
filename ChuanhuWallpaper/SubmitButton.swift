//
//  SubmitButton.swift
//  ChuanhuWallpaper
//
//  Created by Tree Diagram on 2023/1/13.
//

import SwiftUI
import WallpapperLib

struct SubmitButton: View {
    var wallpapers: [WallpaperImage] = []
    @State var showErrorMessage = false
    @State var errorMessage = ""
    let wallpaperGenerator = WallpaperGenerator()
    var disableSubmit = false
    
    var body: some View {
        Button {
            var pictureInfos: [PictureInfo] = []
            for wallpaper in wallpapers{
                pictureInfos.append(PictureInfo( fileName: wallpaper.fileName, isPrimary: wallpaper.isPrimary, isForLight: wallpaper.isFor == .light, isForDark: wallpaper.isFor == .dark, altitude: wallpaper.altitude, azimuth: wallpaper.azimuth))
            }
            if let outputFileName = showSavePanel(){
                do {
                    try wallpaperGenerator.generate(pictureInfos: pictureInfos, baseURL: URL(string: "/")!, outputFileName: outputFileName)
                } catch (let error as WallpapperError) {
                    showErrorMessage = true
                    errorMessage = "Unexpected error occurs: \(error.message)"
                } catch {
                    showErrorMessage = true
                    errorMessage = "Really Unexpected error occurs: \(error)"
                }
            }
        } label: {
            Label {
                Text("Save Wallpaper")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .alert(isPresented: $showErrorMessage) {
            Alert(title: Text("An Error Occured"), message: Text(errorMessage), dismissButton: .cancel())
        }
        .disabled(disableSubmit)
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton()
    }
}
