//
//  ReactCardView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit


class ReactCardView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var numberOfLinksLabel: UILabel!
    @IBOutlet private weak var numberOfFollowingLabel: UILabel!
    @IBOutlet private weak var numberOfLikesLabel: UILabel!
    @IBOutlet private weak var parentView: UIView!
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        loadViewFromNib()
        configureUI()
    }
}

// MARK: Private Handlers

extension ReactCardView {
    private func configureUI() {
        parentView.layer.cornerRadius = 10
    }
}

// MARK: Setter

extension ReactCardView {
    func setNumberOfLinks(_ number: Int?) {
        numberOfLinksLabel.text = "\(String(describing: number ?? 0))"
    }
    
    func setNumberOfFollowing(_ number: Int?) {
        numberOfFollowingLabel.text = "\(String(describing: number ?? 0))K"
    }
    
    func setNumberOfLikes(_ number: Int?) {
        numberOfLikesLabel.text = "\(String(describing: number ?? 0))K"
    }
}
