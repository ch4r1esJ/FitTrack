//
//  ExerciseCell.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    var onDetailsTapped: (() -> Void)?
    
    private let exerciseImageView = UIImageView()
    private let nameLabel = UILabel()
    private let muscleTagLabel = PaddingLabel()
    private let equipmentTagLabel = PaddingLabel()
    private let checkButton = UIButton(type: .custom)
    private let containerview = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        exerciseImageView.image = nil
        nameLabel.text = nil
        muscleTagLabel.text = nil
        equipmentTagLabel.text = nil
    }
    
    private func setupUI() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        containerview.backgroundColor = .systemGray6
        containerview.layer.cornerRadius = 16
        containerview.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseImageView.contentMode = .scaleAspectFill
        exerciseImageView.clipsToBounds = true
        exerciseImageView.layer.cornerRadius = 12
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        muscleTagLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        muscleTagLabel.textColor = .systemBlue
        muscleTagLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        muscleTagLabel.layer.cornerRadius = 10
        muscleTagLabel.clipsToBounds = true
        muscleTagLabel.textAlignment = .center
        muscleTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        equipmentTagLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        equipmentTagLabel.textColor = .systemGray
        equipmentTagLabel.backgroundColor = UIColor.systemGray5
        equipmentTagLabel.layer.cornerRadius = 10
        equipmentTagLabel.clipsToBounds = true
        equipmentTagLabel.textAlignment = .center
        equipmentTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkButton.setImage(UIImage(named: "backButton"), for: .normal)
        checkButton.tintColor = .darkGray
        checkButton.contentHorizontalAlignment = .fill
        checkButton.contentVerticalAlignment = .fill
        checkButton.imageView?.contentMode = .scaleAspectFit
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerview)
        containerview.addSubview(exerciseImageView)
        containerview.addSubview(nameLabel)
        containerview.addSubview(muscleTagLabel)
        containerview.addSubview(equipmentTagLabel)
        containerview.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            containerview.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            exerciseImageView.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: 12),
            exerciseImageView.centerYAnchor.constraint(equalTo: containerview.centerYAnchor),
            exerciseImageView.widthAnchor.constraint(equalToConstant: 70),
            exerciseImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: exerciseImageView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: exerciseImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -8),
            
            muscleTagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            muscleTagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            muscleTagLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            equipmentTagLabel.centerYAnchor.constraint(equalTo: muscleTagLabel.centerYAnchor),
            equipmentTagLabel.leadingAnchor.constraint(equalTo: muscleTagLabel.trailingAnchor, constant: 8),
            
            checkButton.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -16),
            checkButton.centerYAnchor.constraint(equalTo: containerview.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 20),
            checkButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func didTapCheck() {
        onDetailsTapped?()
    }
    
    func configure(with exercise: Exercise, isSelected: Bool) {
        nameLabel.text = exercise.name
        muscleTagLabel.text = exercise.primaryMuscles.first?.capitalized ?? exercise.muscleGroup
        equipmentTagLabel.text = exercise.equipment
        
        if exercise.category == "custom" {
            exerciseImageView.image = UIImage(named: exercise.images.first ?? "exercise1")
        } else {
            exerciseImageView.loadImage(from: exercise.thumbnailURL)
        }
        
        updateSelection(isSelected)
    }
    
    private func updateSelection(_ isSelected: Bool) {
        if isSelected {
            containerview.backgroundColor = UIColor(red: 235/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
            containerview.layer.borderColor = UIColor(red: 170/255.0, green: 210/255.0, blue: 255/255.0, alpha: 1.0).cgColor
            containerview.layer.borderWidth = 2
            
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkButton.tintColor = .systemBlue
            checkButton.isUserInteractionEnabled = false
        } else {
            containerview.backgroundColor = .white
            containerview.layer.borderColor = UIColor.clear.cgColor
            containerview.layer.borderWidth = 0
            
            checkButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
            checkButton.tintColor = .systemGray
            checkButton.isUserInteractionEnabled = true
        }
    }
}
