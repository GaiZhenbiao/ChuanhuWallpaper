//
//  WallpaperCell.swift
//  ChuanhuWallpaper
//
//  Created by LiYanan2004 on 2023/1/28.
//

import SwiftUI

struct WallpaperCell<Actions: View>: View {
    @State private var image = Image(systemName: "exclamationmark.square.fill")
    @Binding var wallpaper: WallpaperImage
    var mode: WallpaperMode
    var namespace: Namespace.ID
    @State private var showEditPopover = false
    @State private var isHovering = false
    @State private var text = ""
    @ViewBuilder var actionButtons: () -> Actions
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            image
                .resizable()
                .matchedGeometryEffect(id: wallpaper.id, in: namespace)
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                        .matchedGeometryEffect(id: "\(wallpaper.id) mask", in: namespace)
                )
            Text(wallpaper.fileName)
                .font(.title3)

            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    if mode == .time {
                        Text(wallpaper.time, style: .time)
                    } else {
                        if let azimuth = wallpaper.azimuth,
                           azimuth.isNormal {
                            Text("Azimuth: \(String(format: "%.2f", azimuth))")
                        }

                        if let altitude = wallpaper.altitude,
                           altitude.isNormal {
                            Text("Altitude: \(String(format: "%.2f", altitude))")
                        }
                    }
                }
                HStack(spacing: 10) {
                    if wallpaper.isFor == .light {
                        Image(systemName: "sun.max")
                    } else if wallpaper.isFor == .dark {
                        Image(systemName: "moon")
                    }
                    if wallpaper.isPrimary {
                        Image(systemName: "photo")
                    }
                }
                .padding(.bottom, 8)
            }
            .foregroundColor(.secondary)
        }
        .matchedGeometryEffect(id: "\(wallpaper.id) container", in: namespace)
        .frame(maxWidth: 200, maxHeight: .infinity)
        .padding()
        .background(
            Color.secondary
                .opacity(0.05)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.2))
                )
        )
        .overlay(
            Group {
                if isHovering || showEditPopover {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
            }
            , alignment: .bottom
        )
        .cornerRadius(10)
        .onHover { isHovering = $0 }
        .onTapGesture { showEditPopover = true }
        .onAppear {
            if let nsImage = NSImage(contentsOfFile: wallpaper.filePath.path) {
                image = Image(nsImage: nsImage)
            }
        }
        .popover(isPresented: $showEditPopover, arrowEdge: .bottom) {
            Form {
                if mode == .solar {
                    TextField("Altitude", value: $wallpaper.altitude, formatter: formatter)
                    TextField("Azimuth", value: $wallpaper.azimuth, formatter: formatter)
                } else if mode == .time {
                    DatePicker("Time", selection: $wallpaper.time)
                }
                Divider()
                actionButtons()
            }
            .frame(width: 200)
            .padding()
        }
        .transition(
            .modifier(active: CardDeleteEffect(isActive: false), identity: CardDeleteEffect(isActive: true))
        )
    }
}

struct WallpaperCell_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperCell(wallpaper: .constant(.placeholder()), mode: .solar, namespace: Namespace().wrappedValue) {
            Button("Delete") {
                
            }
        }
    }
}


fileprivate struct CardDeleteEffect: ViewModifier {
    var isActive: Bool
    @State private var animate: Bool
    @State private var dismiss: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        animate = !isActive
        dismiss = !isActive
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0.5)
            .scaleEffect(animate ? 1.2 : 1)
            .scaleEffect(dismiss ? 0 : 1)
            .opacity(dismiss ? 0 : 1)
            .blur(radius: isActive ? 0 : 5)
            .onChange(of: isActive) { _ in
                withAnimation(.spring(response: 0.3)) {
                    animate.toggle()
                }
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    withAnimation(.spring(response: 0.3)) {
                        dismiss.toggle()
                    }
                }
            }
    }
}