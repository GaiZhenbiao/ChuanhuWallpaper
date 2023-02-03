//
//  BlankWallpaper.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI

struct BlankWallpaper: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .opacity(0.1)
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle.bold())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: 200)
        .padding(5)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        BlankWallpaper()
    }
}
