//
//  InstructionsList.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct InstructionsList: View {
    let instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                InstructionRow(number: index + 1, text: instruction)
                    .padding(.horizontal, 20)
            }
        }
    }
}
