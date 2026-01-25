//
//  ExerciseImageView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct ExerciseImageView: View {
    let imageURL: String
    let hasMultipleImages: Bool
    let isAnimating: Bool
    let onToggleAnimation: () -> Void
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "figure.strengthtraining.traditional")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Color.gray.opacity(0.1))
            
            if hasMultipleImages {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: onToggleAnimation) {
                            Image(systemName: isAnimating ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
                .frame(height: 300)
            }
        }
    }
}
