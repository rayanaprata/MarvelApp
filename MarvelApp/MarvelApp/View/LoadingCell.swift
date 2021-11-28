//
//  LoadingCell.swift
//  MarvelApp
//
//  Created by C94280a on 22/11/21.
//

import UIKit
import Lottie

class LoadingCell: UICollectionViewCell {

    var animateView: AnimationView = {
        let animateView = AnimationView(name: "loading")
        animateView.translatesAutoresizingMaskIntoConstraints = false
        return animateView
    }()
    

    var backgroundview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        contentView.addSubview(backgroundview)
        backgroundview.addSubview(animateView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func addLoading() {
        animateView.loopMode = .loop
        animateView.animationSpeed = 1.8
        animateView.isHidden = false
        animateView.play()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundview.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundview.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundview.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            animateView.centerYAnchor.constraint(equalTo: backgroundview.centerYAnchor),
            animateView.centerXAnchor.constraint(equalTo: backgroundview.centerXAnchor),
            animateView.heightAnchor.constraint(equalToConstant: 50.0),
            animateView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }

}
