//
//  RegisterHeaderView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/7/26.
//


//
//  RegisterHeaderView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct RegisterHeaderView: View {
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
                
                Text("Sign Up For Free")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Quickly make your account in 1 minute.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
            }
            .padding(.top, 120)
        }
    }
}

#Preview {
    RegisterHeaderView()
}
