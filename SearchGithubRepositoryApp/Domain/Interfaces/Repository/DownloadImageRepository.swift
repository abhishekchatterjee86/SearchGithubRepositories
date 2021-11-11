//
//  DownloadImageRepository.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import Foundation

protocol DownloadImageRepository {
    
    func fetchImage(with imagePath: String,
                    completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
