//
//  TemplatesViewController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/11/26.
//

import UIKit

class TemplatesViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel: TemplatesViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise Templates"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .label
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newTemplateButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let icon = UIImage(systemName: "doc.text", withConfiguration: iconConfig)
        
        button.setImage(icon, for: .normal)
        button.setTitle("Create Template", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 12
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var exploreButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let icon = UIImage(systemName: "magnifyingglass", withConfiguration: iconConfig)
        
        button.setImage(icon, for: .normal)
        button.setTitle("Other Templates", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 12
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let collectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 14, bottom: 25, right: 14)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemGray6
        view.showsVerticalScrollIndicator = false
        view.delaysContentTouches = false
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleLabel
        view.backgroundColor = .systemGray6
        
        setupView()
        registerCell()
        bindViewModel()
        viewModel.fetchExercises()
    }
    
    // MARK: - Methods
    
    func setupView() {
        view.addSubview(collectionView)
        view.addSubview(filterStackView)
        
        filterStackView.addArrangedSubview(newTemplateButton)
        filterStackView.addArrangedSubview(exploreButton)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: filterStackView.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }
    
    private func registerCell() {
        collectionView.register(TemplatesCell.self, forCellWithReuseIdentifier: TemplatesCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onTemplateUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func deleteTemplate(at indexPath: IndexPath) {
            let alert = UIAlertController(
                title: "Delete Template?",
                message: "This action cannot be undone.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
               
                self?.viewModel.deleteTemplate(at: indexPath.item)
                self?.collectionView.deleteItems(at: [indexPath])
            })
            
            present(alert, animated: true)
        }
}

extension TemplatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplatesCell.identifier, for: indexPath) as! TemplatesCell
        
                let template = viewModel.templates[indexPath.item]
                cell.configure(with: template)
        
        cell.onDeleteTapped = { [weak self] in

            self?.deleteTemplate(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TemplatesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxWidth = collectionView.bounds.width
        
        let paddingLeft: CGFloat = 14
        let paddingRight: CGFloat = 14
        let spaceBetween: CGFloat = 5
        
        let totalPadding = paddingLeft + paddingRight + (spaceBetween * 2)
        
        let itemSize = (maxWidth - totalPadding) / 2
        let finalWidth = floor(itemSize)
        
        return CGSize(width: finalWidth, height: 170)
    }
}
