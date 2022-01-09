//
//  DetailsViewController.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit
import Kingfisher
import CoreData

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    var characterTouch: Hero
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate let imageDetail: ImageWithBlur = {
        let imageDetail = ImageWithBlur()
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        imageDetail.contentMode = .scaleAspectFill
        imageDetail.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor,
                                UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientLayer.frame = imageDetail.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 10
        imageDetail.layer.insertSublayer(gradientLayer, at: 0)
        
        return imageDetail
    }()
    
    fileprivate lazy var labelName: UILabel = {
        let labelName = UILabel(frame: .zero)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.font = UIFont(name: "Helvetica-Bold", size: 28.0)
        labelName.textColor = .white
        return labelName
    }()
    
    fileprivate lazy var labelTitleDescription: UILabel = {
        let labelComics = UILabel(frame: .zero)
        labelComics.translatesAutoresizingMaskIntoConstraints = false
        labelComics.text = "Description:"
        labelComics.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        labelComics.textColor = .white
        return labelComics
    }()
    
    fileprivate lazy var labelDescription: UILabel = {
        let labelListComics = UILabel()
        labelListComics.translatesAutoresizingMaskIntoConstraints = false
        labelListComics.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        labelListComics.font = UIFont(name: "Helvetica", size: 16.0)
        labelListComics.textColor = .white
        labelListComics.numberOfLines = 0
        return labelListComics
    }()
    
    fileprivate lazy var labelTitleComics: UILabel = {
        let labelComics = UILabel(frame: .zero)
        labelComics.translatesAutoresizingMaskIntoConstraints = false
        labelComics.text = "Comics which feature this character:"
        labelComics.numberOfLines = 0
        labelComics.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        labelComics.textColor = .white
        return labelComics
    }()
    
    fileprivate lazy var labelComics: UILabel = {
        let labelListComics = UILabel()
        labelListComics.translatesAutoresizingMaskIntoConstraints = false
        labelListComics.text = ""
        labelListComics.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        labelListComics.font = UIFont(name: "Helvetica", size: 16.0)
        labelListComics.textColor = .white
        labelListComics.numberOfLines = 0
        return labelListComics
    }()
    
    fileprivate lazy var labelTitleSeries: UILabel = {
        let labelComics = UILabel(frame: .zero)
        labelComics.translatesAutoresizingMaskIntoConstraints = false
        labelComics.text = "Series in which this character appears:"
        labelComics.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        labelComics.textColor = .white
        return labelComics
    }()
    
    fileprivate lazy var labelSeries: UILabel = {
        let labelListComics = UILabel()
        labelListComics.translatesAutoresizingMaskIntoConstraints = false
        labelListComics.text = ""
        labelListComics.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        labelListComics.font = UIFont(name: "Helvetica", size: 16.0)
        labelListComics.textColor = .white
        labelListComics.numberOfLines = 0
        return labelListComics
    }()
    
    fileprivate lazy var labelTitleEvents: UILabel = {
        let labelComics = UILabel(frame: .zero)
        labelComics.translatesAutoresizingMaskIntoConstraints = false
        labelComics.text = "Events in which this character appears:"
        labelComics.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        labelComics.textColor = .white
        return labelComics
    }()
    
    fileprivate lazy var labelEvents: UILabel = {
        let labelListComics = UILabel()
        labelListComics.translatesAutoresizingMaskIntoConstraints = false
        labelListComics.text = ""
        labelListComics.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        labelListComics.font = UIFont(name: "Helvetica", size: 16.0)
        labelListComics.textColor = .white
        labelListComics.numberOfLines = 0
        return labelListComics
    }()
    
    // MARK: Initialization
    init(_ character: Hero) {
        self.characterTouch = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Methods
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "marvel-logo.png")
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
        labelName.text = characterTouch.name
        if let imageURL = characterTouch.image {
            if let url = URL(string: imageURL) {
                imageDetail.kf.setImage(with: url,
                                        options: [.cacheOriginalImage],
                                        completionHandler: { result in })
            }
        }
        
        if characterTouch.resultDescription != "" {
            labelDescription.text = characterTouch.resultDescription
        } else {
            labelDescription.text = "There are no descriptions of this character!"
        }
        
        if characterTouch.comics != "" {
            labelComics.text = characterTouch.comics
        } else {
            labelComics.text = "No comic info featuring this character!"
        }
        
        if characterTouch.series != "" {
            labelSeries.text = characterTouch.series
        } else {
            labelSeries.text = "No series info featuring this character!"
        }
        
        if characterTouch.events != "" {
            labelEvents.text = characterTouch.events
        } else {
            labelEvents.text = "No events info featuring this character!"
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(labelName)
        contentView.addSubview(imageDetail)
        contentView.addSubview(labelTitleDescription)
        contentView.addSubview(labelDescription)
        contentView.addSubview(labelTitleComics)
        contentView.addSubview(labelComics)
        contentView.addSubview(labelTitleSeries)
        contentView.addSubview(labelSeries)
        contentView.addSubview(labelTitleEvents)
        contentView.addSubview(labelEvents)
        setupConstraints()
    }
    
    func applyBlur(frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.8).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 10
        imageDetail.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageDetail.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageDetail.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            labelName.topAnchor.constraint(equalTo: imageDetail.bottomAnchor, constant: 30),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            labelTitleDescription.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 20),
            labelTitleDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelTitleDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelDescription.topAnchor.constraint(equalTo: labelTitleDescription.bottomAnchor, constant: 10),
            labelDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelTitleComics.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 20),
            labelTitleComics.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelTitleComics.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelComics.topAnchor.constraint(equalTo: labelTitleComics.bottomAnchor, constant: 10),
            labelComics.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelComics.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelTitleSeries.topAnchor.constraint(equalTo: labelComics.bottomAnchor, constant: 20),
            labelTitleSeries.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelTitleSeries.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelSeries.topAnchor.constraint(equalTo: labelTitleSeries.bottomAnchor, constant: 10),
            labelSeries.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelSeries.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelTitleEvents.topAnchor.constraint(equalTo: labelSeries.bottomAnchor, constant: 20),
            labelTitleEvents.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelTitleEvents.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            labelEvents.topAnchor.constraint(equalTo: labelTitleEvents.bottomAnchor, constant: 10),
            labelEvents.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelEvents.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            labelEvents.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
