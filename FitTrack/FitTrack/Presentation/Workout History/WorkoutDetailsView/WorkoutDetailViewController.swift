//
//  WorkoutDetailViewController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit

class WorkoutDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let workout: CompletedWorkout
    var onTapBack: (() -> Void)?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = workout.templateName
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statsGridStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Workout Log"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var exercisesStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    // MARK: - Init
    init(workout: CompletedWorkout) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithWorkout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(statsGridStack)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(exercisesStackView)
        
        setupStatsGrid()
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            statsGridStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statsGridStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsGridStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: statsGridStack.bottomAnchor, constant: 30),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            exercisesStackView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 16),
            exercisesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exercisesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            exercisesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func didTapBack() { onTapBack?() }
    
    private func setupStatsGrid() {
        let durationStat = StatisticsView(title: "DURATION", value: formatDuration(workout.duration), icon: "clock")
        let volumeStat = StatisticsView(title: "VOLUME", value: "\(Int(workout.totalVolume))", icon: "scalemass")
        
        let row1 = UIStackView(arrangedSubviews: [durationStat, volumeStat])
        row1.axis = .horizontal
        row1.distribution = .fillEqually
        row1.spacing = 12
        
        let setsStat = StatisticsView(title: "SETS", value: "\(workout.completedSets)", icon: "number")
        let exercisesStat = StatisticsView(title: "EXERCISES", value: "\(workout.exercises.count)", icon: "dumbbell.fill")
        
        let row2 = UIStackView(arrangedSubviews: [setsStat, exercisesStat])
        row2.axis = .horizontal
        row2.distribution = .fillEqually
        row2.spacing = 12
        
        statsGridStack.addArrangedSubview(row1)
        statsGridStack.addArrangedSubview(row2)
    }
    
    private func configureWithWorkout() {
        dateLabel.text = formatDate(workout.endDate)
        
        for exercise in workout.exercises {
            let exerciseCard = ExerciseDetailCard()
            exerciseCard.configure(with: exercise)
            exercisesStackView.addArrangedSubview(exerciseCard)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d • h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes)"
    }
}
