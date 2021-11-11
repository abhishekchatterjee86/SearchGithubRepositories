//
//  UIViewController.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

extension UIViewController {
    
    class func loadFromNib<T: UIViewController>() -> T {
         return T(nibName: String(describing: self), bundle: nil)
    }
}
