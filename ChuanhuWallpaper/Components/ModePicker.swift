//
//  ModePicker.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/29.
//

import SwiftUI

struct ModePicker: View {
    @Binding var mode: WallpaperMode
    @State private var showMessage = false
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        Button {
            currentTask?.cancel()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                if mode == .solar {
                    mode = .time
                } else if mode == .time {
                    mode = .appearance
                } else {
                    mode = .solar
                }
                showMessage = true
                currentTask = Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // 2s
                    guard !Task.isCancelled else { return }
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                        showMessage = false
                    }
                }
            }
        } label: {
            HStack {
                symbol
                if showMessage {
                    message
                }
            }
        }
        .buttonStyle(.plain)
        .padding(5)
        .background(Color.button)
        .cornerRadius(8)
        .font(.title2)
        .contentShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3))
        )
    }
    
    @ViewBuilder
    var symbol: some View {
        switch mode {
        case .appearance:
            Image("appearance")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primary)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .transition(.modifier(active: RotateInOut(present: false, degrees: 360), identity: RotateInOut(present: true, degrees: 0)))
        case .solar:
            Image(systemName: "sun.max")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .transition(.modifier(active: RotateInOut(present: false, degrees: 0), identity: RotateInOut(present: true, degrees: 360)))
        case .time:
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .transition(.modifier(active: RotateInOut(present: false, degrees: 360), identity: RotateInOut(present: true, degrees: 0)))
        }
    }
    
    @ViewBuilder
    var message: some View {
        switch mode {
        case .time: Text("Time Mode")
        case .solar: Text("Solar Mode")
        case .appearance: Text("Light/Dark Mode")
        }
    }
}

fileprivate struct RotateInOut: ViewModifier {
    let present: Bool
    let degrees: Double
    
    func body(content: Content) -> some View {
        content
            .blur(radius: present ? 0 : 2)
            .opacity(present ? 1 : 0)
            .rotationEffect(.degrees(degrees))
            .scaleEffect(present ? 1 : 0)
    }
}

struct ModePicker_Previews: PreviewProvider {
    @State static var mode = WallpaperMode.solar
    static var previews: some View {
        ModePicker(mode: $mode).padding()
    }
}
