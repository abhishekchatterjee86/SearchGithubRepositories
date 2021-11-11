//
//  FetchGithubReposUseCase.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

struct FetchGithubReposUseCaseRequestValue {
    let query: String
    let page: Int
}

protocol FetchGithubReposUseCase {
    func execute(requestValue: FetchGithubReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoryList, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchGithubReposUseCase: FetchGithubReposUseCase {
    
    private let repository: ReposListRepository
    
    init(repository: ReposListRepository) {
        self.repository = repository
    }
    
    func execute(requestValue: FetchGithubReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoryList, Error>) -> Void) -> Cancellable? {
        
        return repository.fetchGithubReposList(query: requestValue.query, page: requestValue.page,
                                               completion: { result in completion(result) })
    }
}
