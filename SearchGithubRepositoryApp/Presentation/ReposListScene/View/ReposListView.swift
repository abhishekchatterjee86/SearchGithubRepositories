//
//  ReposListView.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

class ReposListView: UIView {
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, RepositoryData>
    
    var searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    private var nextPageLoadingSpinner: UIActivityIndicatorView?

    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource: DiffableDataSource = makeDataSource()

    var viewModel: ReposListViewModel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        setUpViews()
        registerCell()
        setupConstraints()
        configureSearchController()
    }
    
    private func setUpViews() {
        backgroundColor = .clear
        tableView.delegate = self
        
        [tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: ReposListTableViewCell.identifier, bundle: Bundle.main),
                           forCellReuseIdentifier: ReposListTableViewCell.identifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.showsSearchResultsButton = true
        searchBar.placeholder = "Enter GitHub repository name"
        searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func makeDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tableView, cellProvider: { (collectionView, indexPath, data) -> UITableViewCell? in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ReposListTableViewCell.identifier,
                                                          for: indexPath) as? ReposListTableViewCell
            cell?.set(data: data)
            
            if indexPath.row == self.viewModel.items.value.count - 1 {
                self.viewModel.didLoadNextPage()
            }
            return cell
        })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard Thread.isMainThread else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items.value)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func reload() {
        applySnapshot()
        tableView.reloadData()
    }
    
    func updateLoading(_ loading: ReposListViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
}

extension ReposListView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didChangeSearch(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ReposListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRepositoryList(at: indexPath.row)
    }
}
