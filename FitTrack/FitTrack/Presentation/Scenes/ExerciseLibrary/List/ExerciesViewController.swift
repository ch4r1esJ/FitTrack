//
//  ExerciesViewController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import UIKit
import SwiftUI
import Combine

class ExercisesViewController: UIViewController {
    
    private let viewModel: ExerciseViewModel
    lazy var filterView = FilterView(viewModel: viewModel)
    
    var onAddExerciseTapped: (() -> Void)?
    var didSelectExercises: (([Exercise]) -> Void)?
    var onShowExerciseDetails: ((Exercise) -> Void)?
    var onCreateExerciseTapped: (() -> Void)?
    
    private let backButton = UIButton(type: .custom)
    private let searchBar = UISearchBar()
    private let exerciseList: UICollectionView
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let floatingAddButton = UIButton(type: .system)
    
    init(viewModel: ExerciseViewModel, diContainer: AppDIContainer) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth * 0.94, height: screenHeight * 0.12)
        
        self.exerciseList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupUI()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchExercises()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchExercises()
    }
    
    private func setupUI() {
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.tintColor = .darkGray
        backButton.contentHorizontalAlignment = .fill
        backButton.contentVerticalAlignment = .fill
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Exercise Library"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setTitle("Create", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "Search exercises"
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseList.backgroundColor = .systemGray6
        exerciseList.showsVerticalScrollIndicator = false
        exerciseList.translatesAutoresizingMaskIntoConstraints = false
        exerciseList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        floatingAddButton.backgroundColor = .systemBlue
        floatingAddButton.setTitleColor(.white, for: .normal)
        floatingAddButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        floatingAddButton.layer.cornerRadius = 25
        floatingAddButton.layer.shadowColor = UIColor.black.cgColor
        floatingAddButton.layer.shadowOpacity = 0.3
        floatingAddButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingAddButton.layer.shadowRadius = 6
        floatingAddButton.alpha = 0
        floatingAddButton.transform = CGAffineTransform(translationX: 0, y: 50)
        floatingAddButton.addTarget(self, action: #selector(floatingAddTapped), for: .touchUpInside)
        floatingAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(filterView)
        view.addSubview(exerciseList)
        view.addSubview(floatingAddButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 55),
                        
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            filterView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            filterView.heightAnchor.constraint(equalToConstant: 45),
            
            exerciseList.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 8),
            exerciseList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            exerciseList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exerciseList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            floatingAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            floatingAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCollectionView() {
        exerciseList.register(ExerciseCell.self, forCellWithReuseIdentifier: "ExerciseCell")
        exerciseList.dataSource = self
        exerciseList.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onExercisesUpdated = { [weak self] in
            self?.exerciseList.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
        
        viewModel.onSelectionUpdated = { [weak self] count in
            self?.updateFloatingButton()
        }
    }
    
    @objc private func backTapped() {
        onAddExerciseTapped?()
    }
    
    @objc private func createTapped() {
        onCreateExerciseTapped?()
    }
    
    @objc private func floatingAddTapped() {
        let selectedExercises = viewModel.getSelectedExercises()
        didSelectExercises?(selectedExercises)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
}

extension ExercisesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ExercisesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
        cell.onDetailsTapped = { [weak self] in
            self?.onShowExerciseDetails?(exercise)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercise = viewModel.filteredExercises[indexPath.item]
        
        viewModel.toggleSelection(for: exercise)
        collectionView.reloadItems(at: [indexPath])
        
        searchBar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension ExercisesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
