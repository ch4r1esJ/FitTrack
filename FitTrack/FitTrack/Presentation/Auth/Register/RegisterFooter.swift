//
//  RegisterFooter.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/7/26.
//

import SwiftUI

struct RegisterFooter: View {
    let onSignInTapped: () -> Void
    
    var body: some View {
        HStack {
            Text("Already have an account?")
            
            Button {
                onSignInTapped()
            } label: {
                Text("Sign In")
                    .foregroundStyle(.blue)
                    .bold()
                    .underline()
            }
        }
    }
}
