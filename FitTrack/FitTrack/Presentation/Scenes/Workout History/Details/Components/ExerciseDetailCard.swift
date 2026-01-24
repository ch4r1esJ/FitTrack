//
//  ExerciseDetailCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit

class ExerciseDetailCard: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let muscleGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tableContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private let setsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(exerciseNameLabel)
        containerView.addSubview(muscleGroupLabel)
        containerView.addSubview(tableContainer)
        tableContainer.addSubview(setsStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            exerciseNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            muscleGroupLabel.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 4),
            muscleGroupLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            tableContainer.topAnchor.constraint(equalTo: muscleGroupLabel.bottomAnchor, constant: 20),
            tableContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            setsStackView.topAnchor.constraint(equalTo: tableContainer.topAnchor),
            setsStackView.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor),
            setsStackView.trailingAnchor.constraint(equalTo: tableContainer.trailingAnchor),
            setsStackView.bottomAnchor.constraint(equalTo: tableContainer.bottomAnchor)
        ])
    }
    
    func configure(with exercise: CompletedExercise) {
        exerciseNameLabel.text = exercise.exerciseName
        muscleGroupLabel.text = "\(exercise.muscleGroup) • \(exercise.equipment)"
        
        setsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let headerView = HeaderView()
        setsStackView.addArrangedSubview(headerView)
        
        for set in exercise.sets {
            let setView = RowView()
            setView.configure(with: set)
            setsStackView.addArrangedSubview(setView)
        }
    }
}
