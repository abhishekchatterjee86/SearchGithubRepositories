//
//  ReposListFlowCoordinator.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

protocol ReposListFlowCoordinatorDependencies  {
    func makeReposListViewController(closures: ReposListViewModelActions) -> ReposListViewController
    func makeRepoDetailsViewController(data: RepositoryData) -> RepoDetailsViewController
}

class ReposListFlowCoordinator: NSObject {
    private weak var navigationController: UINavigationController?
    private let dependencies: ReposListFlowCoordinatorDependencies
    
    private weak var reposListViewController: ReposListViewController?
    
    init(navigationController: UINavigationController,
         dependencies: ReposListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let closures = ReposListViewModelActions(showRepoDetails: showRepoDetails)
        let viewController = dependencies.makeReposListViewController(closures: closures)
        navigationController?.pushViewController(viewController, animated: false)
        reposListViewController = viewController
    }
    
    private func showRepoDetails(data: RepositoryData) {
        let vc = dependencies.makeRepoDetailsViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
