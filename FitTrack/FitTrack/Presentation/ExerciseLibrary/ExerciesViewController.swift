//
//  ExerciesViewController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import UIKit
import Combine

class ExerciesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ExerciseViewModel
    lazy var filterView = FilterView(viewModel: viewModel)
    var onAddExerciseTapped: (() -> Void)?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let image = UIImage(named: "backButton")
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray

        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.imageView?.contentMode = .scaleAspectFit

        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search exercises"
        sb.backgroundImage = UIImage()
        sb.searchBarStyle = .minimal
        sb.delegate = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private let exerciseList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth * 0.94, height: screenHeight * 0.12)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemGray6
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise Library"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func didTapBack() {
        onAddExerciseTapped?()
    }
    
    private let addedExerciseCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var floatingAddButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 25
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0, y: 50)
        
        button.addTarget(self, action: #selector(didTapFloatingAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
                
        setupView()
        registerCell()
        bindViewModel()
        viewModel.fetchExercises()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
    
    func updateCount(_ count: Int) {
        addedExerciseCount.text = "(\(count))"
    }
    
    @objc private func didTapAdd() {
        print("Add button tapped")
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.onExercisesUpdated = { [weak self] in
            self?.exerciseList.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
        
        viewModel.onSelectionUpdated = { [weak self] count in
            self?.updateCount(count)
        }
        
        viewModel.onSelectionUpdated = { [weak self] _ in
            self?.updateFloatingButton()
        }
    }
    
    private func updateFloatingButton() {
        let title = viewModel.addButtonTitle
        let isVisible = viewModel.isAddButtonVisible
        
        floatingAddButton.setTitle(title, for: .normal)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut
        ) {
            if isVisible {
                self.floatingAddButton.alpha = 1
                self.floatingAddButton.transform = .identity
            } else {
                self.floatingAddButton.alpha = 0
                self.floatingAddButton.transform = CGAffineTransform(translationX: 0, y: 50)
            }
        }
    }
    
    @objc private func didTapFloatingAdd() {
        let selectedExercises = viewModel.getSelectedExercises()
    }
    
    private func registerCell() {
        exerciseList.register(ExerciseCell.self, forCellWithReuseIdentifier: "ExerciseCell")
        exerciseList.dataSource = self
        exerciseList.delegate = self
    }
    
    private func setupView() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(addedExerciseCount)
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(filterView)
        view.addSubview(exerciseList)
        view.addSubview(floatingAddButton)
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            backButton.widthAnchor.constraint(equalToConstant: 35),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 55),
            
            addedExerciseCount.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addedExerciseCount.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            filterView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            filterView.heightAnchor.constraint(equalToConstant: 48),
            
            exerciseList.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 8),
            exerciseList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            exerciseList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exerciseList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            floatingAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            floatingAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        exerciseList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
}

extension ExerciesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ExerciesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as? ExerciseCell else {
            return UICollectionViewCell()
        }
        
        let exercise = viewModel.filteredExercises[indexPath.item]
        let isSelected = viewModel.isSelected(exercise)
        
        cell.configure(with: exercise, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercise = viewModel.filteredExercises[indexPath.item]
        print("Selected: \(exercise.name)")
        
        viewModel.toggleSelection(for: exercise)
        collectionView.reloadItems(at: [indexPath])
        
        searchBar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension ExerciesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
