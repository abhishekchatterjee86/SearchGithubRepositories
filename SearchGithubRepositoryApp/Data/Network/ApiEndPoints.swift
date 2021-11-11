//
//  ApiEndPoints.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

struct ApiEndPoints {
    
    static func getGithubRepos(with articlesRequestDTO: ReposListRequestDTO) -> Endpoint<ReposListResponseDTO> {
        
        return Endpoint(path: "search/repositories",
                        method: .get,
                        queryParametersEncodable: articlesRequestDTO)
    }
    
    static func getImage(path: String) -> Endpoint<Data> {
      
        return Endpoint(path: path,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
