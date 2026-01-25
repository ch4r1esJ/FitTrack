//
//  ActivityCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import SwiftUI

struct ActivityCard: View {
    @State var activity: Activities
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray5)
                .cornerRadius(15)
            
            VStack {
                HStack(alignment: .top ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                        
                        Text(activity.subtitle)
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundStyle(activity.tintColor)
                }
                
                Text(activity.amount)
                    .font(.title)
                    .bold()
                    .padding()
            }
            .padding()
        }
    }
}
