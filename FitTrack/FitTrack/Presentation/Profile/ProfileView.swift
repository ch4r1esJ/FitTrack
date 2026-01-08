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
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
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
    }
}
