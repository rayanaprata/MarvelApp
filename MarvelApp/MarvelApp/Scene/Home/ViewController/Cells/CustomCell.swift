//
//  CustomCell.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit
import Kingfisher

class CustomCell: UICollectionViewCell {
    
    // MARK: Properties
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let imageCell: ImageWithBlur = {
        let imageView = ImageWithBlur()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    lazy var labelTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension CustomCell: CodeView {
    
    func buildViewHierarchy() {
        contentView.addSubview(mainStackView)
        mainStackView.addSubview(imageCell)
        mainStackView.addSubview(labelTitle)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageCell.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            imageCell.leftAnchor.constraint(equalTo: mainStackView.leftAnchor),
            imageCell.rightAnchor.constraint(equalTo: mainStackView.rightAnchor),
            imageCell.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            
            labelTitle.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -5),
            labelTitle.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
        labelTitle.textColor = .white
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        includesAccessibilityInTheProject()
    }
    
    func includesAccessibilityInTheProject() {
        mainStackView.isAccessibilityElement = true
        mainStackView.accessibilityTraits = .button
        self.contentView.accessibilityElements = [mainStackView]
    }
    
}
