//
//  RemoteImageView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct RemoteImage: View {
    let url: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString = url, !urlString.isEmpty {
                SVGImageView(
                    urlString: urlString,
                    size: CGSize(width: size, height: size),
                    tintColor: nil
                )
            } else {
                Circle().fill(Color.gray.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
