//
//  WorkoutHistoryViewController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import UIKit

class WorkoutHistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: WorkoutHistoryViewModel
    private let emptyState = EmptyStateView()
    var didSelectWorkout: ((CompletedWorkout) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise History"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .label
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemGroupedBackground
        table.separatorStyle = .none
        
        table.refreshControl = refreshControl
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    // MARK: - Init
    
    init(viewModel: WorkoutHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCell()
        bindViewModel()
        viewModel.loadWorkouts()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.titleView = titleLabel
        
        view.addSubview(tableView)
        view.addSubview(emptyState)
        view.addSubview(loadingIndicator)
        
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            
            emptyState.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyState.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyState.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyState.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func registerCell() {
        tableView.register(WorkoutHistoryCell.self, forCellReuseIdentifier: "WorkoutHistoryCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onWorkoutsUpdated = { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
            
            self.emptyState.isHidden = !self.viewModel.sections.isEmpty
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.loadWorkouts()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension WorkoutHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            header.textLabel?.textColor = .label
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryCell", for: indexPath) as? WorkoutHistoryCell else {
            return UITableViewCell()
        }
        
        let workout = viewModel.sections[indexPath.section].workouts[indexPath.row]
        
        cell.configure(with: workout)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let workout = viewModel.sections[indexPath.section].workouts[indexPath.row]
        
        didSelectWorkout?(workout)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.confirmDelete(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func confirmDelete(at indexPath: IndexPath) {
        let workoutToDelete = viewModel.sections[indexPath.section].workouts[indexPath.row]
        
        let alert = UIAlertController(
            title: "Delete Workout",
            message: "Are you sure you want to delete this workout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteWorkout(workoutToDelete)
        })
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
