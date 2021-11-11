//
//  RepositoryData.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

struct RepositoryData: Equatable, Identifiable, Hashable {
    typealias Identifier = String
    let id: Identifier
    let name: String
    let language: String
    let starsCount: Int
    let createdDate: String
    let ownerLogin: String
    let ownerAvatarUrl: String
}

struct RepositoryList: Equatable {
    let repos: [RepositoryData]
}
