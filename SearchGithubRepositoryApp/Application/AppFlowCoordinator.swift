//
//  AppFlowCoordinator.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import UIKit

class AppFlowCoordinator {
    
    private let appDIContainer: AppDIContainer
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let reposSceneDIContainer = appDIContainer.makeReposListSceneDIContainer()
        let flow = reposSceneDIContainer.makeReposListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
