//
//  StandardButtonStyle.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI

struct StandardButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .font(.title3)
            .opacity(isEnabled ? 1 : 0.5)
            .buttonStyle(.plain)
            .background(Color.button)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.3), radius: 1, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.1))
            )
    }
}

extension ButtonStyle where Self == StandardButtonStyle {
    static var standard: StandardButtonStyle {
        StandardButtonStyle()
    }
}
