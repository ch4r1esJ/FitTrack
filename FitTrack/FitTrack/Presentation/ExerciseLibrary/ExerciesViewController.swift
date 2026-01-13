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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let exerciseList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
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
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .black
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private var backgroundImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "backgroundimageed")
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
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
        navigationItem.titleView = titleLabel
//        runOneTimeUpload()
        setupSearchController()
//        setupBackgroundImage()
        setupView()
        registerCell()
        bindViewModel()
        viewModel.fetchExercises()
        
        view.backgroundColor = .systemGray6
        exerciseList.backgroundColor = .systemGray6

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Methods
    
    func runOneTimeUpload() {
        let uploader = ExerciseUploader()
        uploader.uploadAllExercises()
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
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search exercises"
        searchController.searchBar.backgroundImage = UIImage()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
//    private func setupBackgroundImage() { // TODO: Delete
//        view.addSubview(backgroundImage)
//        backgroundImage.frame = view.bounds
//    }
    
    private func registerCell() {
        exerciseList.register(ExerciseCell.self, forCellWithReuseIdentifier: "ExerciseCell")
        exerciseList.dataSource = self
        exerciseList.delegate = self
    }
    
    private func setupView() {
        view.addSubview(filterView)
        view.addSubview(exerciseList)
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            filterView.heightAnchor.constraint(equalToConstant: 48),
            
            exerciseList.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 8),
            exerciseList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            exerciseList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exerciseList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
}

extension ExerciesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.updateSearchText(searchText)
    }
}

extension ExerciesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as? ExerciseCell else {
            return UICollectionViewCell()
        }
        
        let exercise = viewModel.filteredExercises[indexPath.item]
        cell.configure(with: exercise)
        
        return cell
    }
}

extension ExerciesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercise = viewModel.filteredExercises[indexPath.item]
        print("Selected: \(exercise.name)")
    }
}
