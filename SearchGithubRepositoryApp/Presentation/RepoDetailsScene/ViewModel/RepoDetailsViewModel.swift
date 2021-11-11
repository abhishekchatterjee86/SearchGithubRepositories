//
//  RepoDetailsViewModel.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import Foundation

protocol RepoDetailsViewModelInput {
    func updateAvatarImage()
    func didClickedLike(flag: Bool)
}

protocol RepoDetailsViewModelOutput {
    var name: String { get }
    var star: String { get }
    var owner: String { get }
    var language: String { get }
    var identifier: String { get }
    var creationDate: String { get }
    var isLiked: Bool { get }
    var buttonTitle: String { get }
    var avatarImage: Observable<Data?> { get }
}

protocol RepoDetailsViewModel: RepoDetailsViewModelInput, RepoDetailsViewModelOutput { }

final class DefaultRepoDetailsViewModel: RepoDetailsViewModel {
    private let avatarImagePath: String?
    private let repository: DownloadImageRepository
    private let imageBaseUrl = "https://avatars.githubusercontent.com/"
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    
    let name: String
    let star: String
    let owner: String
    let language: String
    let identifier: String
    let creationDate: String
    let avatarImage: Observable<Data?> = Observable(nil)
    
    var isLiked: Bool {
        let savedItems = Store<[[String: Bool]]>.getSavedItems()
        if let items = savedItems, items.contains(identifier) {
            return true
        }
        return false
    }
    
    var buttonTitle: String {
        return isLiked ? "Unlike" : "Like"
    }
    
    init(data: RepositoryData, repository: DownloadImageRepository) {
        self.name = data.name
        self.star = "\(data.starsCount)"
        self.owner = data.ownerLogin
        self.language = data.language
        self.identifier = data.id
        self.creationDate = data.createdDate
        self.avatarImagePath = data.ownerAvatarUrl
        self.repository = repository
    }
}

extension DefaultRepoDetailsViewModel {
    
    func updateAvatarImage() {
        guard let path = avatarImagePath else { return }
        let imagePath = path.replacingOccurrences(of: imageBaseUrl, with: "")
        
        imageLoadTask = repository.fetchImage(with: imagePath) { result in
            switch result {
            case .success(let data):
                self.avatarImage.value = data
            case .failure: break
            }
            self.imageLoadTask = nil
        }
    }
    
    func didClickedLike(flag: Bool) {
        if flag {
            try? Store<[[String: Bool]]>.write([[identifier: flag]])
        } else {
            try? Store.delete([identifier: true])
        }
    }
}
