//
//  ReposDetailsViewController.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

class RepoDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var repoCreationDateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.borderWidth = 1.0
            avatarImageView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private var viewModel: RepoDetailsViewModel!
    
    private lazy var isLiked = true
    
    static func create(with viewModel: RepoDetailsViewModel) -> RepoDetailsViewController {
        let view: RepoDetailsViewController = RepoDetailsViewController.loadFromNib()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLiked = viewModel.isLiked
        addNavigationItem()
        bind(to: viewModel)
    }
    
    private func addNavigationItem() {
        let likeButton = UIBarButtonItem(title: viewModel.buttonTitle, style: .done, target: self, action: #selector(likeTapped))
        navigationItem.rightBarButtonItems = [likeButton]
    }
    
    private func bind(to viewModel: RepoDetailsViewModel) {
        nameLabel.text = viewModel.name
        starLabel.text = viewModel.star
        ownerLabel.text = viewModel.owner
        languageLabel.text = viewModel.language
        repoCreationDateLabel.text = viewModel.creationDate
        
        viewModel.avatarImage.observe(on: self) { [weak self] in
            self?.avatarImageView.image = $0.flatMap(UIImage.init)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updateAvatarImage()
    }
    
    @objc func likeTapped(sender: UIBarButtonItem) {
        isLiked = !isLiked
        sender.title = isLiked ? "Unlike" : "Like"
        viewModel.didClickedLike(flag: isLiked)
    }
}
