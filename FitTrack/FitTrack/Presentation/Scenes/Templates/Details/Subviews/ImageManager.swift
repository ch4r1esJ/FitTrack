//
//  ImageManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation
import UIKit
import CryptoKit

struct ImageManager {
    static let shared = ImageManager()
    let fileManager = FileManager.default
    let appGroupID = "group.Me.FitTrack"
    
    private func uniqueFilename(for urlString: String) -> String {
        let hash = SHA256.hash(data: Data(urlString.utf8))
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        
        if let url = URL(string: urlString) {
            let ext = url.pathExtension
            return "\(hashString).\(ext)"
        }
        
        return hashString
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func downloadAndSaveImageAsync(from urlString: String) async -> String? {
        guard let url = URL(string: urlString),
              let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return nil
        }
        
        let filename = uniqueFilename(for: urlString)
        let fileURL = groupURL.appendingPathComponent(filename)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return fileURL.path
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let originalImage = UIImage(data: data) else {
                return nil
            }
            
            guard let resizedImage = resizeImage(originalImage, targetSize: CGSize(width: 80, height: 80)) else {
                return nil
            }
            
            guard let resizedData = resizedImage.jpegData(compressionQuality: 0.8) else {
                return nil
            }
            
            try resizedData.write(to: fileURL, options: [.atomic])
            try fileManager.setAttributes(
                [.protectionKey: FileProtectionType.none],
                ofItemAtPath: fileURL.path
            )
            
            return fileURL.path
        } catch {
            return nil
        }
    }
    
    func getLocalImagePath(for urlString: String) -> String? {
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return nil
        }
        
        let filename = uniqueFilename(for: urlString)
        let fileURL = groupURL.appendingPathComponent(filename)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return fileURL.path
        }
        
        return nil
    }
    
    func clearImageCache() {
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return
        }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: groupURL, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
        }
    }
}
