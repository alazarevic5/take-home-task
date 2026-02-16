//
//  SVGImageCache.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI
import WebKit
import UIKit

final class SVGImageCache {
    static let shared = SVGImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private var inFlightRequests: [String: [(UIImage?) -> Void]] = [:]
    private let lock = NSLock()

    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 100 * 1024 * 1024 // 100MB
    }

    func image(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func addCallback(for key: String, callback: @escaping (UIImage?) -> Void) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        if var existing = inFlightRequests[key] {
            existing.append(callback)
            inFlightRequests[key] = existing
            return false
        } else {
            inFlightRequests[key] = [callback]
            return true
        }
    }

    func notifyCallbacks(for key: String, image: UIImage?) {
        lock.lock()
        let callbacks = inFlightRequests.removeValue(forKey: key) ?? []
        lock.unlock()

        DispatchQueue.main.async {
            callbacks.forEach { $0(image) }
        }
    }
}
