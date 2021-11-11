//
//  DefaultDownloadImageRepository.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import Foundation

final class DefaultDownloadImageRepository {
    
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultDownloadImageRepository: DownloadImageRepository {
    
    func fetchImage(with imagePath: String,
                    completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = ApiEndPoints.getImage(path: imagePath)
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
