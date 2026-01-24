//
//  ProfileViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//


import Combine
import SwiftUI
import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isEditingName = false
    @Published var currentName: String = ""
    @Published var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    @Published var isEditingImage = false
    @Published var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var showAlert = false
    
    var images = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9", "avatar10", "avatar11", "avatar12", "avatar13", "avatar14", "avatar15", "avatar16", "avatar17", "avatar18", "avatar19", "avatar20", "avatar21", "avatar22"]
    @Published var errorMessage: String?
    
    let logoutFinished = PassthroughSubject<Void, Never>()
    
    private let authService: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthRepositoryProtocol) {
        self.authService = authService
        
        if let firebaseName = authService.currentUser?.name, !firebaseName.isEmpty {
            self.profileName = firebaseName
            UserDefaults.standard.setValue(firebaseName, forKey: "profileName")
        } else {
            self.profileName = UserDefaults.standard.string(forKey: "profileName")
        }
    }
    
    var profileFirstName: String {
        guard let name = profileName else { return "User" }
        return name.components(separatedBy: " ").first ?? name
    }
    
    func presentEditName() {
        isEditingName = true
        isEditingImage = false
    }
    
    func presentEditImage() {
        isEditingName = false
        isEditingImage = true
    }
    
    func dismissEdit() {
        isEditingName = false
        isEditingImage = false
    }
    
    func setNewName() {
        guard !currentName.isEmpty else { return }
        
        Task { @MainActor in
            do {
                guard let user = Auth.auth().currentUser else {
                    errorMessage = "No user logged in"
                    return
                }
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = currentName
                try await changeRequest.commitChanges()
                
                UserDefaults.standard.setValue(currentName, forKey: "profileName")
                profileName = currentName
                dismissEdit()
                
            } catch {
                errorMessage = "Failed to update name: \(error.localizedDescription)"
            }
        }
    }
    
    func didSelectNewImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
    
    func presentEmailApp() {
        let emailSubject = "FitTrack - Contact Us"
        let emailRecepient = "charles.janjgava@gmail.com"
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecepient = emailRecepient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(encodedRecepient)?subject=\(encodedSubject)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            DispatchQueue.main.async { [weak self] in 
                guard let self = self else { return }
                self.showAlert = true
            }
        }
    }
    
    func logoutTapped() {
        do {
            try authService.signOut()
            logoutFinished.send()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
