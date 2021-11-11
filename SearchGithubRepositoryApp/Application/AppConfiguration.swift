//
//  AppConfiguration.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

final class AppConfiguration {
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var avatarImageBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var limit: String = {
        guard let limitValue = Bundle.main.object(forInfoDictionaryKey: "Limit") as? String else {
            fatalError("Limit must not be empty in plist")
        }
        return limitValue
    }()
}
