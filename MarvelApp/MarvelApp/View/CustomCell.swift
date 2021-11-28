//
//  CustomCell  .swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    // MARK: Properties
    fileprivate let imageCell: ImageWithBlur = {
        let imageView = ImageWithBlur()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        return imageView
    }()

    fileprivate lazy var labelTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            labelTitle.text = data.title
            imageCell.image = data.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        labelTitle.textColor = .white
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        
        contentView.addSubview(imageCell)
        contentView.addSubview(labelTitle)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageCell.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelTitle.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -5),
            labelTitle.centerXAnchor.constraint(equalTo: imageCell.centerXAnchor)
        ])
    }
    
}
