//
//  EditTemplate.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import SwiftUI

struct TemplateDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Content")
                Spacer()
            }
            .navigationTitle("Create Template")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // TODO: Save Logic
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .cornerRadius(20)
                }
            }
        }
    }
}
