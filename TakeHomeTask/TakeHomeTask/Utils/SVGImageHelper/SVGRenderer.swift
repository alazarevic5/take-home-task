//
//  SVGRenderer.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI
import WebKit
import UIKit

final class SVGRenderer: NSObject {
    static let shared = SVGRenderer()

    private let maxConcurrent = 4
    private var availableRenderers: [SingleSVGRenderer] = []
    private var pendingItems: [(html: String, size: CGSize, key: String, completion: (UIImage?) -> Void)] = []
    private let lock = NSLock()

    private override init() {
        super.init()
        // Pre-create renderers
        for _ in 0..<maxConcurrent {
            availableRenderers.append(SingleSVGRenderer())
        }
    }

    func render(html: String, size: CGSize, cacheKey: String, completion: @escaping (UIImage?) -> Void) {
        lock.lock()

        if let renderer = availableRenderers.popLast() {
            lock.unlock()
            renderer.render(html: html, size: size) { [weak self] image in
                completion(image)
                self?.returnRenderer(renderer)
            }
        } else {
            pendingItems.append((html, size, cacheKey, completion))
            lock.unlock()
        }
    }

    private func returnRenderer(_ renderer: SingleSVGRenderer) {
        lock.lock()

        if let item = pendingItems.first {
            pendingItems.removeFirst()
            lock.unlock()

            renderer.render(html: item.html, size: item.size) { [weak self] image in
                item.completion(image)
                self?.returnRenderer(renderer)
            }
        } else {
            availableRenderers.append(renderer)
            lock.unlock()
        }
    }
}

final class SingleSVGRenderer: NSObject, WKNavigationDelegate {
    private var webView: WKWebView!
    private var currentCompletion: ((UIImage?) -> Void)?
    private var currentSize: CGSize = .zero
    private var timeoutWorkItem: DispatchWorkItem?

    override init() {
        super.init()

        let config = WKWebViewConfiguration()
        config.suppressesIncrementalRendering = true

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = self
    }

    func render(html: String, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        // Must be called on main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.render(html: html, size: size, completion: completion)
            }
            return
        }

        currentCompletion = completion
        currentSize = size
        webView.frame = CGRect(origin: .zero, size: size)

        // Set timeout
        timeoutWorkItem?.cancel()
        let timeout = DispatchWorkItem { [weak self] in
            self?.finishWithImage(nil)
        }
        timeoutWorkItem = timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: timeout)

        webView.loadHTMLString(html, baseURL: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Small delay to ensure rendering is complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.takeSnapshot()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        finishWithImage(nil)
    }

    private func takeSnapshot() {
        let config = WKSnapshotConfiguration()
        config.rect = CGRect(origin: .zero, size: currentSize)
        config.snapshotWidth = NSNumber(value: Double(currentSize.width))

        webView.takeSnapshot(with: config) { [weak self] image, error in
            self?.finishWithImage(image)
        }
    }

    private func finishWithImage(_ image: UIImage?) {
        timeoutWorkItem?.cancel()
        timeoutWorkItem = nil

        let completion = currentCompletion
        currentCompletion = nil

        completion?(image)
    }
}
