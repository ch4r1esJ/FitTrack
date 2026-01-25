//
//  FitnessProfileButton.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/22/26.
//

import SwiftUI

struct FitnessProfileItemButton: View {
    @State var title: String
    @State var image: String
    @State var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
