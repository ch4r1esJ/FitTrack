//
//  EditTemplate.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import SwiftUI

struct TemplateDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var templateTitle: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                VStack {
                    HStack {
                        TextField("Template title", text: $templateTitle)
                            .font(.title3)
                        
                        Button(action: {
                            templateTitle = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.4))
                                .font(.system(size: 20))
                        }
                        .padding(.trailing, 5)
                        
                        .opacity(templateTitle.isEmpty ? 0 : 1)
                        
                        .disabled(templateTitle.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
                
                VStack(spacing: 25) {
                    VStack(spacing: 16) {
                        Image(systemName: "dumbbell")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Get started by adding an exercise to your template.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Button(action: {
                        print("Add Exercise Tapped")
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add exercise")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)
                
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

#Preview {
    TemplateDetailsView()
}
