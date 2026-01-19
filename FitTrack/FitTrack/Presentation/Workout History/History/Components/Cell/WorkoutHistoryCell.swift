//
//  WorkoutHistoryCell.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import UIKit

class WorkoutHistoryCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let accentBlue = UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1.0)
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationBadge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
//        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var volumeStatView = WorkoutStatView(icon: "chart.xyaxis.line", title: "VOLUME", color: accentBlue)
    private lazy var setsStatView = WorkoutStatView(icon: "square.grid.3x3.fill", title: "SETS", color: accentBlue)
    private lazy var exercisesStatView = WorkoutStatView(icon: "dumbbell.fill", title: "EXERCISES", color: accentBlue)
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        workoutNameLabel.text = nil
        dateLabel.text = nil
        durationLabel.text = nil
        volumeStatView.setValue("-")
        setsStatView.setValue("-")
        exercisesStatView.setValue("-")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.masksToBounds = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(workoutNameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(durationBadge)
        durationBadge.addSubview(durationLabel)
        
        containerView.addSubview(statsStackView)
        statsStackView.addArrangedSubview(volumeStatView)
        statsStackView.addArrangedSubview(setsStatView)
        statsStackView.addArrangedSubview(exercisesStatView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            durationBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            durationBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            durationBadge.heightAnchor.constraint(equalToConstant: 28),
            durationBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 65),
            
            durationLabel.centerYAnchor.constraint(equalTo: durationBadge.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationBadge.leadingAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(equalTo: durationBadge.trailingAnchor, constant: -10),
            
            workoutNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            workoutNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            workoutNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationBadge.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: workoutNameLabel.leadingAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with workout: CompletedWorkout) {
        workoutNameLabel.text = workout.templateName
        dateLabel.text = formatDate(workout.endDate)
        durationLabel.text = formatDuration(workout.duration)
        
        volumeStatView.setValue("\(Int(workout.totalVolume)) kg")
        setsStatView.setValue("\(workout.completedSets)/\(workout.totalSets)")
        exercisesStatView.setValue("\(workout.exercises.count)")
    }
        
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "'Today at' h:mm a"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "'Yesterday at' h:mm a"
        } else {
            formatter.dateFormat = "MMM d 'at' h:mm a"
        }
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}
