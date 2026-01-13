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
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.menu = createBodyPartMenu()
        return button
    }()
    
    private lazy var equipmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Any Equipment", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.menu = createEquipmentMenu()
        return button
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
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
        filterStackView.addArrangedSubview(equipmentButton)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            filterStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            filterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),
            filterStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
        
    private func createBodyPartMenu() -> UIMenu {
        let actions = ExerciseConstants.muscleGroups.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateButtonState(self?.bodyPartButton, title: title, isSelected: value != nil)
                self?.viewModel.selectMuscleGroup(value)
            }
        }
        return UIMenu(title: "Select Body Part", children: actions)
    }
    
    private func createEquipmentMenu() -> UIMenu {
        let actions = ExerciseConstants.equipmentTypes.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateButtonState(self?.equipmentButton, title: title, isSelected: value != nil)
                self?.viewModel.selectEquipment(value)
            }
        }
        return UIMenu(title: "Select Equipment", children: actions)
    }
        
    private func updateButtonState(_ button: UIButton?, title: String, isSelected: Bool) {
        guard let button = button else { return }
        
        button.setTitle(title, for: .normal)
        
        if isSelected {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemGray5
            button.setTitleColor(.label, for: .normal)
        }
    }
}
