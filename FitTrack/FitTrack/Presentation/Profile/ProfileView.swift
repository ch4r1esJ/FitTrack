//
//  ProfileView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @AppStorage("profileName") var profileName: String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State private var isEditingImage = false
    @State private var selectedImage: String?
    @State private var images = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9", "avatar10", "avatar11", "avatar12", "avatar13", "avatar14", "avatar15", "avatar16", "avatar17", "avatar18", "avatar19", "avatar20", "avatar21", "avatar22"]
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "avatar1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        isEditingImage = true
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(.primary)
                                    }
                                }
                                .padding()
                            }
                            .shadow(radius: selectedImage == image ? 5 : 0)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                Button {
                    withAnimation {
                        profileImage = selectedImage
                        isEditingImage = false
                    }
                } label: {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: 200)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                        )
                }
                .padding(.bottom)
            }
            
            VStack {
                FitnessProfileButton(title: "Edit name", image: "square.and.pencil") {
                    print("name")
                }
                
                FitnessProfileButton(title: "Edit image", image: "square.and.pencil") {
                    isEditingImage = true
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
        .onAppear {
            selectedImage = profileImage
        }
    }
}

