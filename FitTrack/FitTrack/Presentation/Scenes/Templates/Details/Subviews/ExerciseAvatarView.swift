//
//  ExerciseAvatarView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct ExerciseAvatarView: View {
    let imageUrl: String?
    
    var body: some View {
        if let imageUrl {
            if let uiImage = UIImage(contentsOfFile: imageUrl) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            } else if let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    defaultIcon()
                }
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            } else {
                defaultIcon()
            }
        } else {
            defaultIcon()
        }
    }
    
    func defaultIcon() -> some View {
        Image(systemName: "figure.strengthtraining.traditional")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.blue)
            .padding(8)
            .frame(width: 40, height: 40)
            .background(Color.blue.opacity(0.1))
            .clipShape(Circle())
    }
}
