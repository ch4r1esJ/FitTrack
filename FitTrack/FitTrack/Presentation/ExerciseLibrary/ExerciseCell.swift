//
//  Exercise.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let muscleTagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemBlue
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let equipmentTagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let containerview: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        contentView.addSubview(containerview)
        
        containerview.addSubview(exerciseImageView)
        containerview.addSubview(nameLabel)
        containerview.addSubview(muscleTagLabel)
        containerview.addSubview(equipmentTagLabel)
        containerview.addSubview(arrowImageView)
        
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
            nameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            muscleTagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            muscleTagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            muscleTagLabel.widthAnchor.constraint(equalToConstant: 70),
            muscleTagLabel.heightAnchor.constraint(equalToConstant: 24),
            
            equipmentTagLabel.centerYAnchor.constraint(equalTo: muscleTagLabel.centerYAnchor),
            equipmentTagLabel.leadingAnchor.constraint(equalTo: muscleTagLabel.trailingAnchor, constant: 8),
            equipmentTagLabel.widthAnchor.constraint(equalToConstant: 80),
            equipmentTagLabel.heightAnchor.constraint(equalToConstant: 24),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: containerview.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with exercise: Exercise) {
        nameLabel.text = exercise.name
        muscleTagLabel.text = exercise.muscleGroup
        equipmentTagLabel.text = exercise.equipment
        
        exerciseImageView.loadImages(url: exercise.imageUrl)
    }
}
