//
//  ReposListRepository.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

protocol ReposListRepository {
    
    @discardableResult
    func fetchGithubReposList(query: String,
                              page: Int,
                              completion: @escaping (Result<RepositoryList, Error>) -> Void) -> Cancellable?
}
