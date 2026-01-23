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
    
    
    @State private var isEditingName = false
    @State private var currentName: String = ""
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
                        withAnimation {
                            isEditingName = false
                            isEditingImage = true
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEditingName {
                TextField("Name...", text: $currentName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke()
                )
                
                HStack {
                    FitnessProfileEditingButton(
                        title: "Cancel",
                        backgroundColor: .gray.opacity(0.1)) {
                            withAnimation {
                                isEditingName = false
                            }
                        }
                        .foregroundStyle(.red)
                    
                    FitnessProfileEditingButton(
                        title: "Done",
                        backgroundColor: .primary) {
                            if !currentName.isEmpty {
                                withAnimation {
                                    profileName = currentName
                                    isEditingName = false
                                }
                            }
                        }
                        .foregroundStyle(Color(.systemBackground))
                    
                    Button {
                        
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
                
                FitnessProfileEditingButton(
                    title: "Done",
                    backgroundColor: .primary) {
                        withAnimation {
                            profileImage = selectedImage
                            isEditingImage = false
                        }
                    }
                    .foregroundStyle(Color(.systemBackground))
                    .padding(.bottom)
            }
            
            VStack {
                FitnessProfileItemButton(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        isEditingName = true
                        isEditingImage = false
                    }
                }
                
                FitnessProfileItemButton(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        isEditingName = true
                        isEditingImage = false
                    }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            }
            
            VStack {
                FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                    print("name")
                }
                
                FitnessProfileItemButton(title: "Privacy Policy", image: "doc") {
                    print("image")
                }
                
                FitnessProfileItemButton(title: "Terms of Service", image: "doc") {
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

