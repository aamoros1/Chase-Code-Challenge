//
// ImageCacheManager.swift
// 
// Created by Alex on 6/15/23.
// 

import Foundation

final class ImageCache: NSObject, NSDiscardableContent {
    let imageData: Data
    init(data: Data) {
        imageData = data
    }
    
    func beginContentAccess() -> Bool {
        true
    }
    
    func endContentAccess() {
        
    }
    
    func discardContentIfPossible() {
        
    }
    
    func isContentDiscarded() -> Bool {
        false
    }
}

class ImageCacheManager {
    
    private init() { }

    static let shared = ImageCacheManager()
    var cache = NSCache<NSString, ImageCache>()
}
