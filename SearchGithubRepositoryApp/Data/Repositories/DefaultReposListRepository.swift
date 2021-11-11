//
//  DefaultReposListRepository.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

final class DefaultReposListRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultReposListRepository: ReposListRepository {
    
    func fetchGithubReposList(query: String,
                              page: Int,
                              completion: @escaping (Result<RepositoryList, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = ReposListRequestDTO(page: page, q: query)
        let task = RepositoryTask()
                
        let endpoint = ApiEndPoints.getGithubRepos(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
}
