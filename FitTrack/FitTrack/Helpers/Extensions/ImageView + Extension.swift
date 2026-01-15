//
//  ImageView + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/10/26.
//

import UIKit

extension UIImageView {
    
    private static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 30
        return cache
    }()
    
    func loadImage(from urlString: String, placeholder: UIImage? = UIImage(systemName: "photo")) {
        
        self.image = placeholder
        
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            return
        }
        
        let cacheKey = urlString as NSString
        
        if let cachedImage = Self.imageCache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let loadedImage = UIImage(data: data) else {
                    return
                }
                
                guard let smallImage = loadedImage.preparingThumbnail(of: CGSize(width: 200, height: 200)) else { return }
                
                Self.imageCache.setObject(smallImage, forKey: cacheKey)
                
                await MainActor.run {
                    self.image = smallImage
                }
                
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}
