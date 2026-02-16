//
//  SVGImageView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI
import WebKit
import UIKit



struct SVGImageView: View {
    let url: URL?
    let size: CGSize
    let tintColor: Color?

    @State private var loadedImage: UIImage?
    @State private var loadId = UUID()

    init(url: URL?, size: CGSize = CGSize(width: 20, height: 20), tintColor: Color? = nil) {
        self.url = url
        self.size = size
        self.tintColor = tintColor
    }

    init(urlString: String?, size: CGSize = CGSize(width: 20, height: 20), tintColor: Color? = nil) {
        self.url = urlString.flatMap { URL(string: $0) }
        self.size = size
        self.tintColor = tintColor
    }

    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
            } else if url != nil {
                // Subtle loading state
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
            } else {
                placeholder
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            loadImageIfNeeded()
        }
        .onChange(of: url) { _ in
            loadId = UUID()
            loadedImage = nil
            loadImageIfNeeded()
        }
        .onChange(of: tintColor) { _ in
            loadId = UUID()
            loadedImage = nil
            loadImageIfNeeded()
        }
    }

    private var placeholder: some View {
        Image(systemName: "sportscourt")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(tintColor ?? .white)
    }

    private func loadImageIfNeeded() {
        guard let urlString = url?.absoluteString else { return }

        // Check cache with tint color in key
        let colorHex = tintColor.map { UIColor($0) }.map { hexString(from: $0) } ?? "none"
        let renderSize = CGSize(width: size.width * 3, height: size.height * 3) // 3x for retina
        let cacheKey = "\(urlString)_\(Int(renderSize.width))x\(Int(renderSize.height))_\(colorHex)"

        if let cached = SVGImageCache.shared.image(for: cacheKey) {
            loadedImage = cached
            return
        }

        let currentLoadId = loadId
        let uiColor = tintColor.map { UIColor($0) }

        SVGLoader.shared.loadSVG(from: urlString, size: renderSize, tintColor: uiColor) { image in
            if currentLoadId == self.loadId {
                self.loadedImage = image
            }
        }
    }

    private func hexString(from color: UIColor) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
