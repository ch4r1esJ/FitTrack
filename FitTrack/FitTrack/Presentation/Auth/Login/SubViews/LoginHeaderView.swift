//
//  LoginHeaderView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct LoginHeaderView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Image("background")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                
                Text("Sign In to FitTrack")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("The only bad workout is the one that didn't happen.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
            }
            .padding(.top, 120)
        }
    }
}

#Preview {
    LoginHeaderView()
}
