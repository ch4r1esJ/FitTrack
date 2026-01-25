//
//  FilterView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import UIKit

class FilterView: UIView {
    
    private let viewModel: ExerciseViewModel
    
    private let bodyPartButton = UIButton(type: .system)
    private let equipmentButton = UIButton(type: .system)
    private let filterStackView = UIStackView()
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        bodyPartButton.setTitle("Any Body Part", for: .normal)
        bodyPartButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        bodyPartButton.backgroundColor = .systemGray5
        bodyPartButton.setTitleColor(.label, for: .normal)
        bodyPartButton.layer.cornerRadius = 12
        bodyPartButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        bodyPartButton.translatesAutoresizingMaskIntoConstraints = false
        bodyPartButton.showsMenuAsPrimaryAction = true
        bodyPartButton.menu = createBodyPartMenu()
        
        equipmentButton.setTitle("Any Equipment", for: .normal)
        equipmentButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        equipmentButton.backgroundColor = .systemGray5
        equipmentButton.setTitleColor(.label, for: .normal)
        equipmentButton.layer.cornerRadius = 12
        equipmentButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        equipmentButton.translatesAutoresizingMaskIntoConstraints = false
        equipmentButton.showsMenuAsPrimaryAction = true
        equipmentButton.menu = createEquipmentMenu()
        
        filterStackView.axis = .horizontal
        filterStackView.spacing = 10
        filterStackView.distribution = .fillEqually
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(filterStackView)
        filterStackView.addArrangedSubview(bodyPartButton)
        filterStackView.addArrangedSubview(equipmentButton)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            filterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            filterStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
        
    private func createBodyPartMenu() -> UIMenu {
        let actions = ExerciseConstants.muscleGroups.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateButton(self?.bodyPartButton, title: title, isSelected: value != nil)
                self?.viewModel.selectMuscleGroup(value)
            }
        }
        return UIMenu(title: "Select Body Part", children: actions)
    }
    
    private func createEquipmentMenu() -> UIMenu {
        let actions = ExerciseConstants.equipmentTypes.map { (title, value) in
            UIAction(title: title) { [weak self] _ in
                self?.updateButton(self?.equipmentButton, title: title, isSelected: value != nil)
                self?.viewModel.selectEquipment(value)
            }
        }
        return UIMenu(title: "Select Equipment", children: actions)
    }
        
    private func updateButton(_ button: UIButton?, title: String, isSelected: Bool) {
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
