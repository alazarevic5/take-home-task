//
//  SVGLoader.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI
import WebKit
import UIKit

final class SVGLoader {
    static let shared = SVGLoader()

    private init() {}

    func loadSVG(from urlString: String, size: CGSize, tintColor: UIColor?, completion: @escaping (UIImage?) -> Void) {
        let colorHex = tintColor.map { hexString(from: $0) } ?? "none"
        let cacheKey = "\(urlString)_\(Int(size.width))x\(Int(size.height))_\(colorHex)"

        if let cached = SVGImageCache.shared.image(for: cacheKey) {
            DispatchQueue.main.async {
                completion(cached)
            }
            return
        }

        let shouldLoad = SVGImageCache.shared.addCallback(for: cacheKey, callback: completion)
        guard shouldLoad else { return }

        guard let url = URL(string: urlString) else {
            SVGImageCache.shared.notifyCallbacks(for: cacheKey, image: nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  var svgString = String(data: data, encoding: .utf8) else {
                SVGImageCache.shared.notifyCallbacks(for: cacheKey, image: nil)
                return
            }

            // Apply tint color
            if let tintColor = tintColor {
                let hexColor = self.hexString(from: tintColor)
                svgString = svgString.replacingOccurrences(
                    of: "fill=\"[^\"]*\"",
                    with: "fill=\"\(hexColor)\"",
                    options: .regularExpression
                )
                svgString = svgString.replacingOccurrences(
                    of: "fill:[^;\"]*",
                    with: "fill:\(hexColor)",
                    options: .regularExpression
                )
                // Add fill if SVG doesn't have one
                if !svgString.contains("fill=") && !svgString.contains("fill:") {
                    svgString = svgString.replacingOccurrences(
                        of: "<svg",
                        with: "<svg fill=\"\(hexColor)\""
                    )
                }
            }

            let html = self.createHTML(svg: svgString, size: size)

            DispatchQueue.main.async {
                SVGRenderer.shared.render(html: html, size: size, cacheKey: cacheKey) { image in
                    if let image = image {
                        SVGImageCache.shared.setImage(image, for: cacheKey)
                    }
                    SVGImageCache.shared.notifyCallbacks(for: cacheKey, image: image)
                }
            }
        }.resume()
    }

    private func createHTML(svg: String, size: CGSize) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=\(Int(size.width)), initial-scale=1.0, maximum-scale=1.0">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body {
                    width: \(Int(size.width))px;
                    height: \(Int(size.height))px;
                    background: transparent;
                    overflow: hidden;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                svg {
                    width: 100% !important;
                    height: 100% !important;
                    max-width: 100%;
                    max-height: 100%;
                }
            </style>
        </head>
        <body>\(svg)</body>
        </html>
        """
    }

    private func hexString(from color: UIColor) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
