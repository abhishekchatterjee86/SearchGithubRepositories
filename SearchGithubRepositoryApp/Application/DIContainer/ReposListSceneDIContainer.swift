//
//  GithubReposListSceneDIContainer.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

final class ReposListSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
        
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    
    func makeFetchArticlesUseCase() -> FetchGithubReposUseCase {
        return DefaultFetchGithubReposUseCase(repository: makeGithubReposListRepository())
    }

    // MARK: - Repositories
    
    func makeGithubReposListRepository() -> ReposListRepository {
        return DefaultReposListRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    func makeImagesRepository() -> DownloadImageRepository {
        return DefaultDownloadImageRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    // MARK: - Github Repos List
    
    func makeReposListViewController(closures: ReposListViewModelActions) -> ReposListViewController {
        return ReposListViewController.create(with: makeReposListViewModel(closures: closures))
    }
    
    func makeReposListViewModel(closures: ReposListViewModelActions) -> ReposListViewModel {
        return DefaultArticlesListViewModel(useCase: makeFetchArticlesUseCase(), closures: closures)
    }

    // MARK: - Repo Details
    
    func makeRepoDetailsViewController(data: RepositoryData) -> RepoDetailsViewController {
        return RepoDetailsViewController.create(with: makeRepoDetailsViewModel(data: data))
    }
    
    func makeRepoDetailsViewModel(data: RepositoryData) -> RepoDetailsViewModel {
        return DefaultRepoDetailsViewModel(data: data,
                                            repository: makeImagesRepository())
    }
    
    // MARK: - Flow Coordinators
    
    func makeReposListFlowCoordinator(navigationController: UINavigationController) -> ReposListFlowCoordinator {
        return ReposListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension ReposListSceneDIContainer: ReposListFlowCoordinatorDependencies { }
