//
//  ReposListResponseDTO.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

struct ReposListResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case repos = "items"
    }
    
    let repos: [RepoDTO]
}

extension ReposListResponseDTO {
    
    struct RepoDTO: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case language
            case stars = "stargazers_count"
            case createdAt = "created_at"
            case owner
        }
        
        struct Owner: Decodable {
            let login: String
            let avatarUrl: String?
            
            private enum CodingKeys: String, CodingKey {
                case login
                case avatarUrl = "avatar_url"
            }
        }
        
        let id: Int
        let name: String
        let language: String?
        let stars: Int
        let createdAt: String
        let owner: Owner
    }
}

// MARK: - Mappings to Domain

extension ReposListResponseDTO {
    func toDomain() -> RepositoryList {
        return .init(repos: repos.map { $0.toDomain() })
    }
}

extension ReposListResponseDTO.RepoDTO {
    func toDomain() -> RepositoryData {
        return .init(id: RepositoryData.Identifier(id),
                     name: name,
                     language: language ?? "",
                     starsCount: stars,
                     createdDate: Date.getFormattedDate(string: createdAt),
                     ownerLogin: owner.login,
                     ownerAvatarUrl: owner.avatarUrl ?? "")
    }
}
