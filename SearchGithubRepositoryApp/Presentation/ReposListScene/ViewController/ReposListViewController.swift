//
//  ReposListViewController.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

class ReposListViewController: UIViewController {
    
    private var viewModel: ReposListViewModel!
    
    private lazy var reposListView = ReposListView(frame: .zero)
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: ReposListViewModel) -> ReposListViewController {
        let view = ReposListViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        reposListView.viewModel = viewModel
        viewModel.didFetchRepositoryList()
        bind(to: viewModel)
    }
    
    func setupView() {
        title = "Github Repositories"
        reposListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reposListView)
        
        NSLayoutConstraint.activate([
            reposListView.topAnchor.constraint(equalTo: view.topAnchor),
            reposListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reposListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reposListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind(to viewModel: ReposListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.reposListView.reload() }
        viewModel.loading.observe(on: self) { [weak self] in self?.reposListView.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateSearchQuery(_ query: String) {
        reposListView.searchController.isActive = false
        reposListView.searchController.searchBar.text = query
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    func showAlert(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
