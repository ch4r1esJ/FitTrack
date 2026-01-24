//
//  RowView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit

class RowView: UIView {
    
    private let setNumberLabel = UILabel()
    private let weightLabel = UILabel()
    private let repsLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        [setNumberLabel, weightLabel, repsLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .label
        }
        
        setNumberLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.contentMode = .scaleAspectFit
        
        checkmarkImageView.tintColor = UIColor(red: 0.25, green: 0.35, blue: 1.0, alpha: 1.0)
        
        checkmarkImageView.layer.shadowColor = UIColor.blue.cgColor
        checkmarkImageView.layer.shadowOpacity = 0.2
        checkmarkImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        checkmarkImageView.layer.shadowRadius = 4
        
        addSubview(setNumberLabel)
        addSubview(weightLabel)
        addSubview(repsLabel)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            setNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            setNumberLabel.widthAnchor.constraint(equalToConstant: 70),
            
            weightLabel.leadingAnchor.constraint(equalTo: setNumberLabel.trailingAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            weightLabel.widthAnchor.constraint(equalToConstant: 100),
            
            repsLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor),
            repsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            repsLabel.widthAnchor.constraint(equalToConstant: 110),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 28),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(with set: CompletedSet) {
        setNumberLabel.text = "\(set.setNumber)"
        
        let weightVal = set.actualWeightKg ?? 0
        weightLabel.attributedText = formatValueUnit(value: "\(Int(weightVal))", unit: " kg")
        let repsVal = set.actualReps ?? 0
        repsLabel.attributedText = formatValueUnit(value: "\(repsVal)", unit: " reps")
        
        if set.isCompleted {
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.alpha = 1.0
        } else {
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.alpha = 0.3
        }
    }
    
    private func formatValueUnit(value: String, unit: String) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: value,
            attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        )
        let unitText = NSAttributedString(
            string: unit,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        text.append(unitText)
        return text
    }
}
