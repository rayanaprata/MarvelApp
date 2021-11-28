//
//  HomeViewController.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let data = [
        CustomData(title: "Black Widow", image: UIImage(named: "viuva.png")!),
        CustomData(title: "Wanda Maximoff", image: UIImage(named: "wanda.png")!),
        CustomData(title: "3D-Man", image: UIImage(named: "3d.png")!),
        CustomData(title: "8-Ball", image: UIImage(named: "8ball.png")!),
        CustomData(title: "Adbul Alhazred", image: UIImage(named: "abdul.png")!),
        CustomData(title: "Abomination", image: UIImage(named: "abomination.png")!),
        CustomData(title: "A", image: UIImage(named: "a.png")!),
        CustomData(title: "Aberration", image: UIImage(named: "aberration.png")!),
        CustomData(title: "Abraxas", image: UIImage(named: "abraxas.png")!),
        CustomData(title: "Abigail Brand", image: UIImage(named: "abigail.png")!),
        CustomData(title: "3D-Man", image: UIImage(named: "3d-man.png")!),
        CustomData(title: "Aardwolf", image: UIImage(named: "aardwolf.png")!)
    ]
    
    var featuredCharacteres: [CustomData] = []
    var charactersList: [CustomData] = []
    var dataSourceArr: [CustomData] = []
    var isLoading = false
    
    var characters: Character?
    let api = API()
        
    fileprivate lazy var labelFeaturedCharacters: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let collectionViewFeaturedCharacters: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let textFieldSearch: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        let border = CALayer()
        let width = CGFloat(1.2)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: tf.frame.size.height - (width-1.2), width: tf.frame.size.width*2, height: tf.frame.size.height)
        border.borderWidth = width
        tf.borderStyle = .none
        tf.layer.addSublayer(border)
        tf.layer.masksToBounds = true
        tf.attributedPlaceholder = NSAttributedString(string: "Search characters", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 16.0)
        ])
        
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 16.0, height: 21.0))
        let image = UIImage(named: "search-icon")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 40))
        view.addSubview(imageView)
        tf.leftViewMode = .always
        tf.leftView = view
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    fileprivate lazy var labelCharactersList: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let collectionViewCharactersList: UICollectionView = {
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupUI()
        
//        api.getListCharcters()

        collectionViewFeaturedCharacters.delegate = self
        collectionViewFeaturedCharacters.dataSource = self
        
        collectionViewCharactersList.delegate = self
        collectionViewCharactersList.dataSource = self
        
        textFieldSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: Methods
    private func requestAPI() {
        let url = self.api.setListCharacters()
        api.getListCharacters(urlString: url,
                              method: .GET) { charactersList in
            self.characters = charactersList
            DispatchQueue.main.async {
                print("\(String(describing: self.characters))")
            }
        } failure: { error in
            print(error)
        }

    }
    
    func getData() {
        featuredCharacteres.append(contentsOf: data.prefix(5))
        charactersList.append(contentsOf: data.suffix(from: 5))
        dataSourceArr = charactersList
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let txt = textField.text {
            dataSourceArr = charactersList.filter({ $0.title.hasPrefix(txt) })
            collectionViewCharactersList.reloadData()
        }
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
        
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        setupNavigationController()
        
        labelFeaturedCharacters.text = "FEATURED CHARACTERS"
        labelFeaturedCharacters.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        collectionViewFeaturedCharacters.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        labelCharactersList.text = "MARVEL CHARACTERS LIST"
        labelCharactersList.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        collectionViewCharactersList.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        view.addSubview(labelFeaturedCharacters)
        view.addSubview(collectionViewFeaturedCharacters)
        view.addSubview(labelCharactersList)
        view.addSubview(textFieldSearch)
        view.addSubview(collectionViewCharactersList)
        setupConstraints()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(2)
                self.dataSourceArr.append(contentsOf: self.dataSourceArr)
                DispatchQueue.main.async {
                    self.collectionViewCharactersList.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelFeaturedCharacters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelFeaturedCharacters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            collectionViewFeaturedCharacters.topAnchor.constraint(equalTo: labelFeaturedCharacters.bottomAnchor, constant: 10),
            collectionViewFeaturedCharacters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionViewFeaturedCharacters.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            collectionViewFeaturedCharacters.heightAnchor.constraint(equalToConstant: view.frame.height/4.5),
            
            labelCharactersList.topAnchor.constraint(equalTo: collectionViewFeaturedCharacters.bottomAnchor, constant: 25),
            labelCharactersList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            textFieldSearch.topAnchor.constraint(equalTo: labelCharactersList.bottomAnchor, constant: 10),
            textFieldSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            collectionViewCharactersList.topAnchor.constraint(equalTo: textFieldSearch.bottomAnchor, constant: 25),
            collectionViewCharactersList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionViewCharactersList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            collectionViewCharactersList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

}

extension HomeViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewFeaturedCharacters {
            let character = self.featuredCharacteres[indexPath.row]
            let details = DetailsViewController(character)
            navigationController?.pushViewController(details, animated: true)
        } else {
            let character = self.dataSourceArr[indexPath.row]
            let details = DetailsViewController(character)
            navigationController?.pushViewController(details, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) && !isLoading {
            loadMoreData()
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewFeaturedCharacters {
            return 1
        } else {
            return 2            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewFeaturedCharacters {
            return featuredCharacteres.count
        } else {
            
            if section == 0 {
                return dataSourceArr.count
            } else if section == 1 {
                return 1
            } else {
                return 0
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewFeaturedCharacters {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            cell.data = self.featuredCharacteres[indexPath.item]
            return cell
        } else {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
                cell.data = self.dataSourceArr[indexPath.item]
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                cell.addLoading()
                return cell
            }
            
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewCharactersList && indexPath.section == 1 {
            return CGSize(width: collectionView.bounds.width, height: 80.0)
        } else if collectionView == collectionViewFeaturedCharacters {
            return CGSize(width: 190.0, height: 190.0)
        } else {
            return CGSize(width: ((collectionView.bounds.width/2)-15), height: 166.0)
        }
    }
}
