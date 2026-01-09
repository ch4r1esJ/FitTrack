//
//  FilterView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import UIKit

class FilterView: UIView {
    // MARK: - Properties
    
    private let viewModel: ExerciseViewModel
    
    private lazy var bodyPartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Any Body Part", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.menu = createBodyPartMenu()
        return button
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Any Category", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.menu = createCategoryMenu()
        return button
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        addSubview(filterStackView)
        
        filterStackView.addArrangedSubview(bodyPartButton)
        filterStackView.addArrangedSubview(categoryButton)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            filterStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            filterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            filterStackView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func createBodyPartMenu() -> UIMenu {
        let actions = ExerciseConstants.muscleGroups.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateBodyPartButton(for: value)
                self?.viewModel.selectMuscleGroup(value)
            }
        }
        
        return UIMenu(title: "", children: actions)
    }
    
    private func createCategoryMenu() -> UIMenu {
        let actions = ExerciseConstants.equipmentTypes.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateCategoryButton(for: value)
                self?.viewModel.selectEquipment(value)
            }
        }
        
        return UIMenu(title: "", children: actions)
    }
    
    private func updateBodyPartButton(for value: String?) {
        if let value = value {
            let title = muscleGroupTitle(for: value)
            bodyPartButton.setTitle(title, for: .normal)
            bodyPartButton.backgroundColor = .systemBlue
            bodyPartButton.setTitleColor(.white, for: .normal)
        } else {
            bodyPartButton.setTitle("Any Body Part", for: .normal)
            bodyPartButton.backgroundColor = .systemGray5
            bodyPartButton.setTitleColor(.black, for: .normal)
        }
    }
    
    private func updateCategoryButton(for value: String?) {
        if let value = value {
            let title = equipmentTitle(for: value)
            categoryButton.setTitle(title, for: .normal)
            categoryButton.backgroundColor = .systemBlue
            categoryButton.setTitleColor(.white, for: .normal)
        } else {
            categoryButton.setTitle("Any Category", for: .normal)
            categoryButton.backgroundColor = .systemGray5
            categoryButton.setTitleColor(.black, for: .normal)
        }
    }
        
    private func muscleGroupTitle(for value: String) -> String {
        switch value.lowercased() {
        case "chest": return "Chest"
        case "back": return "Back"
        case "legs": return "Legs"
        case "arms": return "Arms"
        case "shoulders": return "Shoulders"
        case "core": return "Core"
        case "fullbody": return "Full Body"
        case "cardio": return "Cardio"
        default: return "Any Body Part"
        }
    }
    
    private func equipmentTitle(for value: String) -> String {
        switch value.lowercased() {
        case "barbell": return "Barbell"
        case "dumbbell": return "Dumbbell"
        case "cable": return "Cable"
        case "bodyweight": return "Bodyweight"
        case "machine": return "Machine"
        default: return "Any Category"
        }
    }
}

#Preview {
    FilterView(viewModel: ExerciseViewModel(exerciseService: MockExerciseService()))
}
