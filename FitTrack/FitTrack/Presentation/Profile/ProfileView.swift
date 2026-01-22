//
//  ProfileView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("avatar1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Name")
                        .font(.title)
                }
            }
            
            VStack {
                FitnessProfileButton(title: "Edit name", image: "square.and.pencil") {
                    print("name")
                }
                
                FitnessProfileButton(title: "Edit image", image: "square.and.pencil") {
                    print("image")
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            }
            
            VStack {
                FitnessProfileButton(title: "Contact us", image: "envelope") {
                    print("name")
                }
                
                FitnessProfileButton(title: "Privacy policy", image: "doc") {
                    print("image")
                }
                
                FitnessProfileButton(title: "Terms of Service", image: "doc") {
                    print("image")
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding()
            }
            
            CustomButton(
                image: "emptyicon",
                title: "Log Out",
                isVisible: true
            ) {
                viewModel.logoutTapped()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:
                .topLeading)
    }
}

