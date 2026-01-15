//
//  CustomButton.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/5/26.
//

import SwiftUI

struct CustomButton: View {
    let image: String
    let title: String
    var isVisible: Bool = false
    var isLoading: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: isVisible ? .white : .blue))
                } else {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(isVisible ? Color.blue : Color.clear)
        .foregroundStyle(isVisible ? .white : .black)
        .cornerRadius(15)
        .overlay {
            if !isVisible {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
        .disabled(isLoading)
    }
}

