//
//  BaseViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    let indicatorBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureLayout()
        configureNavigationBar()
    }
    
    func configure() {
        view.backgroundColor = Constants.Color.backgroundMain
    }
    
    func configureNavigationBar() {
        
    }
    
    func configureLayout() {
        
    }
}
