//
//  UIView+ActivityIndicator.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

extension UIView {
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = .medium
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        return activityIndicator
    }
}
