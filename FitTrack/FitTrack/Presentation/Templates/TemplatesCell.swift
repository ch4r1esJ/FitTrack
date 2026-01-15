//
//  TemplatesCell.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/11/26.
//

import UIKit
class TemplatesCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "TemplatesCell"
    
    let muscleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.strengthtraining.traditional")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        button.setImage(UIImage(systemName: "trash.fill", withConfiguration: config), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hard Leg Day"
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exerciseCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercises: 10"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Sets: 30"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START WORKOUT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onDeleteTapped: (() -> Void)?
    var onStartTapped: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onDeleteTapped = nil
        onStartTapped = nil
        
    }
    
    // MARK: - Methods
    
    private func layoutCardShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCardShadow()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        
        contentView.addSubview(muscleImage)
        contentView.addSubview(deleteButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(exerciseCountLabel)
        contentView.addSubview(setsCountLabel)
        contentView.addSubview(startButton)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalToConstant: 32),
            
            muscleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            muscleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            muscleImage.widthAnchor.constraint(equalToConstant: 24),
            muscleImage.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: muscleImage.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            exerciseCountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            exerciseCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            setsCountLabel.topAnchor.constraint(equalTo: exerciseCountLabel.bottomAnchor, constant: 2),
            setsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            startButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func configure(with template: WorkoutTemplate) {
        nameLabel.text = template.name.uppercased()
        exerciseCountLabel.text = "Exercises: \(template.totalExercises)"

        setsCountLabel.text = "Sets: \(template.totalSets)"
    }
    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
    
    @objc private func startTapped() {
        onStartTapped?()
    }
}

#Preview {
    TemplatesCell()
}
