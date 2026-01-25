//
//  CustomExerciseView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import SwiftUI

struct CustomExerciseView: View {
    @ObservedObject var viewModel: CustomExerciseViewModel
    var onDismiss: (() -> Void)?
    
    @State private var showingCancelAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exercise Name *")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("Enter exercise name", text: $viewModel.exerciseName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exercise Image")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.availableImages, id: \.self) { imageName in
                                        Button {
                                            withAnimation {
                                                viewModel.selectedImage = imageName
                                            }
                                        } label: {
                                            VStack(spacing: 8) {
                                                Image(imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(viewModel.selectedImage == imageName ? Color.blue : Color.clear, lineWidth: 3)
                                                    )
                                                
                                                if viewModel.selectedImage == imageName {
                                                    Circle()
                                                        .fill(Color.blue)
                                                        .frame(width: 8, height: 8)
                                                }
                                            }
                                            .padding(.leading, 15)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Primary Muscle *")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Menu {
                                ForEach(viewModel.muscleGroups, id: \.self) { muscle in
                                    Button(muscle) {
                                        viewModel.primaryMuscle = muscle
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.primaryMuscle.isEmpty ? "Select primary muscle" : viewModel.primaryMuscle)
                                        .foregroundColor(viewModel.primaryMuscle.isEmpty ? .gray : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Equipment *")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Menu {
                                ForEach(viewModel.equipmentTypes, id: \.self) { equipment in
                                    Button(equipment) {
                                        viewModel.equipment = equipment
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.equipment.isEmpty ? "Select equipment" : viewModel.equipment)
                                        .foregroundColor(viewModel.equipment.isEmpty ? .gray : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty Level")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Menu {
                                ForEach(viewModel.difficultyLevels, id: \.self) { level in
                                    Button(level) {
                                        viewModel.level = level
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.level)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Secondary Muscles (Optional)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Menu {
                                ForEach(viewModel.muscleGroups, id: \.self) { muscle in
                                    Button {
                                        viewModel.toggleSecondaryMuscle(muscle)
                                    } label: {
                                        HStack {
                                            Text(muscle)
                                            if viewModel.secondaryMuscles.contains(muscle) {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.secondaryMuscles.isEmpty ? "Select secondary muscles" : viewModel.secondaryMuscles.joined(separator: ", "))
                                        .foregroundColor(viewModel.secondaryMuscles.isEmpty ? .gray : .primary)
                                        .lineLimit(2)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            
                            if !viewModel.secondaryMuscles.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(viewModel.secondaryMuscles, id: \.self) { muscle in
                                            HStack(spacing: 4) {
                                                Text(muscle)
                                                    .font(.caption)
                                                Button {
                                                    viewModel.toggleSecondaryMuscle(muscle)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(15)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions (Optional)")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                            
                            ForEach(viewModel.instructions.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .foregroundColor(.gray)
                                        .padding(.top, 12)
                                    
                                    TextField("Enter instruction", text: $viewModel.instructions[index])
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    if viewModel.instructions.count > 1 {
                                        Button {
                                            viewModel.removeInstruction(at: index)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .padding(.top, 12)
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                viewModel.addInstruction()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Instruction")
                                }
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.top, 5)
                            }
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            Task {
                                await viewModel.createExercise()
                            }
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Exercise")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("Create Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if viewModel.hasUnsavedChanges {
                            showingCancelAlert = true
                        } else {
                            onDismiss?()
                        }
                    }
                }
            }
        }
        .alert("Discard Changes?", isPresented: $showingCancelAlert) {
            Button("Keep Editing", role: .cancel) { }
            Button("Discard", role: .destructive) {
                onDismiss?()
            }
        } message: {
            Text("Are you sure you want to discard this exercise?")
        }
        .onChange(of: viewModel.isCreated) {
            if viewModel.isCreated {
                onDismiss?()
            }
        }
        
    }
}
