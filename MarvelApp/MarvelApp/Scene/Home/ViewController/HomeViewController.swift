//
//  HomeViewController.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit
import Kingfisher
import CoreData
import ViewAnimator

class HomeViewController: UIViewController {
    
    // MARK: Properties
    let tag: TaggingProtocol
    private let marvelCrypto = MarvelCrypto()
    
    lazy var viewModel = HomeViewModel(
        networkService: NetworkService(crypto: marvelCrypto),
        coreDataManager: CoreDataManager(),
        parseManager: ParseManager()
    )
    
    lazy var emptyStateMessage: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    fileprivate lazy var labelFeaturedCharacters: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionViewCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        sb.searchBarStyle = .minimal
        sb.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        if #available(iOS 13.0, *) {
            sb.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search characters", attributes: [
                .font: UIFont.italicSystemFont(ofSize: 16.0)
            ])
            let border = CALayer()
            let width = CGFloat(1.2)
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: sb.frame.size.height - (width-16), width: sb.frame.size.width*2, height: sb.frame.size.height)
            border.borderWidth = width
            sb.searchTextField.tintColor = .darkGray
            sb.searchTextField.borderStyle = .none
            sb.searchTextField.layer.addSublayer(border)
            sb.searchTextField.layer.masksToBounds = true
            let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 16.0, height: 21.0))
            let image = UIImage(named: "search-icon")
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 40))
            view.addSubview(imageView)
            sb.searchTextField.leftViewMode = .always
            sb.searchTextField.leftView = view
        } else {
            sb.placeholder = "Search characters"
        }
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    fileprivate lazy var labelCharactersList: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionViewCharactersList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(LoadingCell.self, forCellWithReuseIdentifier: "loadingCell")
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: Initialization
    init() {
        self.tag = TaggingFirebase()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.validateInternetConnection()
        setupView()
        setupDelegates()
        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCollectionViewCells()
        tagging()
    }
    
    // MARK: Methods
    fileprivate func tagging() {        
        let screenName = "Home"
        let screenClass = "HomeViewController.swift"
        tag.screenView(screenName: screenName, screenClass: screenClass)
    }
    
    fileprivate func animateCollectionViewCells() {
        let zoomAnimation = AnimationType.zoom(scale: 0.3)
        UIView.animate(views: collectionViewCarousel.visibleCells, animations: [zoomAnimation])
        UIView.animate(views: collectionViewCharactersList.visibleCells, animations: [zoomAnimation], delay: 0.1)
    }
    
    fileprivate func setupDelegates() {
        collectionViewCarousel.delegate = self
        collectionViewCarousel.dataSource = self
        collectionViewCharactersList.delegate = self
        collectionViewCharactersList.dataSource = self
        searchBar.delegate = self
    }
    
    fileprivate func setupNavigationController() {
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        }
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "marvel-logo.png")
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }

}

extension HomeViewController: CodeView {
    
    func buildViewHierarchy() {
        view.addSubview(labelFeaturedCharacters)
        view.addSubview(collectionViewCarousel)
        view.addSubview(labelCharactersList)
        view.addSubview(searchBar)
        view.addSubview(collectionViewCharactersList)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelFeaturedCharacters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelFeaturedCharacters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        
            collectionViewCarousel.topAnchor.constraint(equalTo: labelFeaturedCharacters.bottomAnchor, constant: 10),
            collectionViewCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionViewCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionViewCarousel.heightAnchor.constraint(equalToConstant: view.frame.height/4.5),
        
            labelCharactersList.topAnchor.constraint(equalTo: collectionViewCarousel.bottomAnchor, constant: 25),
            labelCharactersList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        
            searchBar.topAnchor.constraint(equalTo: labelCharactersList.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        
            collectionViewCharactersList.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            collectionViewCharactersList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionViewCharactersList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            collectionViewCharactersList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        labelFeaturedCharacters.text = "FEATURED CHARACTERS"
        labelFeaturedCharacters.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        collectionViewCarousel.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        labelCharactersList.text = "MARVEL CHARACTERS LIST"
        labelCharactersList.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        collectionViewCharactersList.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        setupNavigationController()
        includesAccessibilityInTheProject()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedVoiceOverStatus),
                                               name: UIAccessibility.voiceOverStatusDidChangeNotification,
                                               object: nil)
    }
    
    func includesAccessibilityInTheProject() {
        labelCharactersList.isAccessibilityElement = true
        labelCharactersList.accessibilityTraits = .header
                
        labelFeaturedCharacters.isAccessibilityElement = true
        labelFeaturedCharacters.accessibilityTraits = .header
                
        self.view.accessibilityElements = [labelFeaturedCharacters,
                                           collectionViewCarousel,
                                           labelCharactersList,
                                           searchBar,
                                           collectionViewCharactersList]
    }
    
    @objc private func changedVoiceOverStatus() {
        if UIAccessibility.isVoiceOverRunning {
            print("VoiceOver is Running")
        } else {
            print("VoiceOver isn't Running")
        }
    }

}
