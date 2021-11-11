//
//  ReposListViewModel.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 19/10/21.
//

import Foundation

struct ReposListViewModelActions {
    let showRepoDetails: (RepositoryData) -> Void
}

enum ReposListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ReposListViewModelInput {
    func didLoadNextPage()
    func didCancelSearch()
    func didFetchRepositoryList()
    func didChangeSearch(text: String)
    func didSelectRepositoryList(at index: Int)
}

protocol ReposListViewModelOutput {
    var items: Observable<[RepositoryData]> { get }
    var loading: Observable<ReposListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var errorTitle: String { get }
}

protocol ReposListViewModel: ReposListViewModelInput, ReposListViewModelOutput {}

final class DefaultArticlesListViewModel: ReposListViewModel {
    
    private let useCase: FetchGithubReposUseCase
    private let closures: ReposListViewModelActions?
    
    var currentPage: Int = 0
    var nextPage: Int { currentPage + 1 }

    private var pages: [RepositoryData] = []
    private var reposLoadTask: Cancellable? { willSet { reposLoadTask?.cancel() } }
    
    let items: Observable<[RepositoryData]> = Observable([])
    let loading: Observable<ReposListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let errorTitle = NSLocalizedString("Error", comment: "")

    // MARK: - Init
    
    init(useCase: FetchGithubReposUseCase,
         closures: ReposListViewModelActions? = nil) {
        self.useCase = useCase
        self.closures = closures
    }
    
    private func appendRepo(_ page: RepositoryList) {
        pages = page.repos
        currentPage = currentPage + 1
        if page.repos.count == 0 {
            currentPage = 0
        } else {
            items.value = page.repos
        }
    }
    
    private func resetPages() {
        currentPage = 0
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(query: String, loading: ReposListViewModelLoading) {
        self.loading.value = loading
        self.query.value = query
        
        reposLoadTask = useCase.execute(
            requestValue: .init(query: query, page: nextPage),
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendRepo(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
            })
    }
    
    private func handle(error: Error) {
        self.error.value = error.localizedDescription
    }
    
    private func update(query: String) {
        resetPages()
        load(query: query, loading: .fullScreen)
    }
}

extension DefaultArticlesListViewModel {
    
    func didLoadNextPage() {
        guard loading.value == .none else { return }
        load(query: .init(query.value), loading: .nextPage)
    }
    
    func didCancelSearch() {
        reposLoadTask?.cancel()
    }
    
    func didFetchRepositoryList() {
        load(query: "test", loading: .fullScreen)
    }
    
    func didChangeSearch(text: String) {
        guard !text.isEmpty else { return }
        update(query: text)
    }
    
    func didSelectRepositoryList(at index: Int) {
        closures?.showRepoDetails(pages[index])
    }
}
