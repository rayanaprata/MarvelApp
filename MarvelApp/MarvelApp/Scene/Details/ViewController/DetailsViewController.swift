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
    let tag: TaggingProtocol
    var viewModel: DetailsViewModel
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate let imageDetail: ImageWithBlur = {
        let imageDetail = ImageWithBlur()
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        imageDetail.contentMode = .scaleAspectFill
        imageDetail.clipsToBounds = true
        
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
    
    private(set) lazy var labelDescription: UILabel = {
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
    
    private(set) lazy var labelComics: UILabel = {
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
    
    lazy var labelSeries: UILabel = {
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
    
    lazy var labelEvents: UILabel = {
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
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        self.tag = TaggingFirebase()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagging()
    }
    
    // MARK: Methods
    fileprivate func tagging() {
        let screenName = "Details"
        let screenClass = "DetailsViewController.swift"
        tag.screenView(screenName: screenName, screenClass: screenClass)
    }

}

extension DetailsViewController: CodeView {
    
    func buildViewHierarchy() {
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
    }
    
    func setupConstraints() {
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
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "marvel-logo.png")
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
        labelName.text = viewModel.characterTouch.name
        
        let imageURL = viewModel.characterTouch.thumbnail.getUrlImage()
        if imageURL == self.viewModel.urlImageNotAvailable {
            imageDetail.image = UIImage(named: "ImageNotAvailable.jpg")
        } else {
            if let url = URL(string: imageURL) {
                imageDetail.kf.setImage(with: url,
                                            options: [.cacheOriginalImage],
                                            completionHandler: { result in })
            }
        }
        
        viewModel.validatesAndConcatenatesDetailsScreenInformation()
        includesAccessibilityInTheProject()
    }
    
    func includesAccessibilityInTheProject() {
        imageDetail.isAccessibilityElement = true
        imageDetail.accessibilityLabel = "\(viewModel.characterTouch.name)"
        
        labelName.isAccessibilityElement = true
        labelName.accessibilityTraits = .header
        
        labelTitleDescription.isAccessibilityElement = true
        labelTitleDescription.accessibilityLabel = "\(labelTitleDescription.text ?? "") \(labelDescription.text ?? "")"
        
        labelTitleComics.isAccessibilityElement = true
        labelTitleComics.accessibilityLabel = "\(labelTitleComics.text ?? "") \(labelComics.text ?? "")"
        
        labelTitleSeries.isAccessibilityElement = true
        labelTitleSeries.accessibilityLabel = "\(labelTitleSeries.text ?? "") \(labelSeries.text ?? "")"
        
        labelTitleEvents.isAccessibilityElement = true
        labelTitleEvents.accessibilityLabel = "\(labelTitleEvents.text ?? "") \(labelEvents.text ?? "")"
        
        self.scrollView.accessibilityElements = [imageDetail,
                                            labelName,
                                            labelTitleDescription,
                                            labelTitleComics,
                                            labelTitleSeries,
                                            labelTitleEvents]
    }
    
}
