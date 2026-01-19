//
//  StatisticsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit

class StatisticsView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 16
        
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.90, green: 0.94, blue: 1.0, alpha: 1.0).cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.tintColor = UIColor(red: 0.00, green: 0.60, blue: 1.00, alpha: 1.0)
        
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    init(title: String, value: String, icon: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        iconImageView.image = UIImage(systemName: icon)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(valueLabel)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            valueLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
