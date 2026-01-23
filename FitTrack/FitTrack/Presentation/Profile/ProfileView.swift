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
                Image(viewModel.profileImage ?? "avatar1")
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
                            viewModel.presentEditImage()
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Welcome, home")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(viewModel.profileFirstName)
                        .font(.title)
                }
            }
            
            if viewModel.isEditingName {
                TextField("Name...", text: $viewModel.currentName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke()
                )
                
                HStack {
                    FitnessProfileEditingButton(
                        title: "Cancel", tint: .red,
                        backgroundColor: .gray.opacity(0.1)) {
                            withAnimation {
                                viewModel.dismissEdit()
                            }
                        }
                        .foregroundStyle(.red)
                    
                    FitnessProfileEditingButton(
                        title: "Done", tint: .white,
                        backgroundColor: .blue) {
                            if !viewModel.currentName.isEmpty {
                                viewModel.setNewName()
                            }
                        }
                        .foregroundStyle(Color(.systemBackground))
                }
            }
            
            if viewModel.isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    viewModel.didSelectNewImage(name: image)
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if viewModel.selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(.primary)
                                    }
                                }
                                .padding()
                            }
                            .shadow(radius: viewModel.selectedImage == image ? 5 : 0)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                FitnessProfileEditingButton(
                    title: "Done", tint: .white,
                    backgroundColor: .blue) {
                        withAnimation {
                            viewModel.setNewImage()
                        }
                    }
                    .foregroundStyle(.green)
//                    .padding(.bottom)
            }
            
            VStack {
                FitnessProfileItemButton(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditName()
                    }
                }
                
                FitnessProfileItemButton(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditImage()
                    }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            }
            
            VStack {
                FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                    viewModel.presentEmailApp()
                }
                
                Link(destination: URL(string: "https://github.com/ch4r1esJ/FitTrack")!) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                        
                        Text("Check Out Github")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
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
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("We were unable to open your mail application. Please, make sure you have one installed.")
        }
    }
}

