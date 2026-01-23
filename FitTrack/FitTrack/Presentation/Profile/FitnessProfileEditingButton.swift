//
//  FitnessProfileEditingButton.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/23/26.
//

import SwiftUI

struct FitnessProfileEditingButton: View {
    @State var title: String
    @State var backgroundColor: Color
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
            .padding()
            .frame(maxWidth: 200)
            .foregroundColor(.red)
            .background(
                RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
            )
        }
    }
}
