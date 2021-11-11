//
//  ReposListTableViewCell.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

class ReposListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!

    class var identifier: String {
        return "\(self)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(data: RepositoryData) {
        nameLabel.text = data.name
        starLabel.text = "\(data.starsCount)"
        languageLabel.text = data.language
    }
}
