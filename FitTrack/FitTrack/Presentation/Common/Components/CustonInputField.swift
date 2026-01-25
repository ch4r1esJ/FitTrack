//
//  CustonInputField.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/5/26.
//

import SwiftUI

struct CustomInputField: View {
    let title: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var isFocused: FocusState<Bool>.Binding
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .bold()
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(isFocused.wrappedValue ? .blue : .gray)
                
                if isSecure && !isVisible {
                    SecureField(placeholder, text: $text)
                        .focused(isFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    TextField(placeholder, text: $text)
                        .focused(isFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                if isSecure {
                    Button {
                        isVisible.toggle()
                    } label: {
                        Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(15)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isFocused.wrappedValue ? Color.blue : Color.gray, lineWidth: 1)
            }
            .shadow(color: isFocused.wrappedValue ? .blue.opacity(1) : .clear, radius: 2)
        }
    }
}
