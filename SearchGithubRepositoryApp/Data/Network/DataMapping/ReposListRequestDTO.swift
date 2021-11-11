//
//  ReposListRequestDTO.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

struct ReposListRequestDTO: Encodable {
    let page: Int
    let q: String
}
