//
//  ProfileViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//


import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var isEditingName = false
    @Published var currentName: String = ""
    @Published var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    @Published var isEditingImage = false
    @Published var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    var images = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9", "avatar10", "avatar11", "avatar12", "avatar13", "avatar14", "avatar15", "avatar16", "avatar17", "avatar18", "avatar19", "avatar20", "avatar21", "avatar22"]
    @Published var errorMessage: String?
    
    let logoutFinished = PassthroughSubject<Void, Never>()
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
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
        profileName = currentName
        UserDefaults.standard.setValue(currentName, forKey: "profileName")
        self.dismissEdit()
    }
    
    func didSelectNewImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
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
