//
//  HeaderView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit

class HeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        layer.cornerRadius = 8
        
        let setLabel = createLabel(text: "SET")
        let weightLabel = createLabel(text: "WEIGHT")
        let repsLabel = createLabel(text: "REPS")
        let doneLabel = createLabel(text: "DONE")
        
        addSubview(setLabel)
        addSubview(weightLabel)
        addSubview(repsLabel)
        addSubview(doneLabel)
        
        NSLayoutConstraint.activate([
            setLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            setLabel.widthAnchor.constraint(equalToConstant: 70),
            
            weightLabel.leadingAnchor.constraint(equalTo: setLabel.trailingAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            weightLabel.widthAnchor.constraint(equalToConstant: 100),
            
            repsLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor),
            repsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            repsLabel.widthAnchor.constraint(equalToConstant: 110),
            
            doneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }
}
