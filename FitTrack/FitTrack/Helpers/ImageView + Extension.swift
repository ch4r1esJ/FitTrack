//
//  ImageView + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/10/26.
//

import UIKit

extension UIImageView {
    
    func loadImages(url: String) {
        self.image = nil
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let loadedImage = UIImage(data: data) else {
                    print("It's not an image")
                    return
                }
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            } catch {
                print("Can't load an image \(error.localizedDescription)")
            }
        }
    }
}
