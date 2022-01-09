//
//  HomeViewController.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit
import Kingfisher
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: Properties
    var isLoading = false
    var characters: Character?
    var api: MarvelAPI?
    
    var list: [Hero] = []
    var carouselCharacters: [Hero] = []
    var searchList: [Hero] = []
    var listCharacters: [Hero] = []
    
    fileprivate lazy var labelFeaturedCharacters: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let collectionViewCarousel: UICollectionView = {
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
            sb.searchTextField.borderStyle = .none
            sb.searchTextField.layer.addSublayer(border)
            sb.searchTextField
                .layer.masksToBounds = true
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
    convenience init(api: MarvelAPI) {
        self.init()
        self.api = api
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateInternetConnection()
        loadData()
        setupUI()
        
        collectionViewCarousel.delegate = self
        collectionViewCarousel.dataSource = self
        
        collectionViewCharactersList.delegate = self
        collectionViewCharactersList.dataSource = self
        
        searchBar.delegate = self
    }
    
    // MARK: Methods
    func validateInternetConnection() {
        if !InternetConnectionManager.isConnectedToNetwork(){
            let alert = UIAlertController(title: "Atenção", message: "Por gentileza verifique sua conexão com a internet", preferredStyle: .alert)
            let buttonCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(buttonCancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadData() {
        if getNumberOfCharactersInCoreData() == 0 {
            requestAPI()
        } else {
            let dataPersisted = getDataFromCoreData()
            self.carouselCharacters.append(contentsOf: dataPersisted.prefix(5))
            self.listCharacters.append(contentsOf: dataPersisted.suffix(from: 5))
            self.searchList = self.listCharacters
            collectionViewCarousel.reloadData()
            collectionViewCharactersList.reloadData()
        }
    }
    
    func requestAPI() {
        if !self.isLoading {
            self.isLoading = true
            let offset = self.getOffset()
            guard let api = self.api else { return }
            let url = api.setNewCharacters(Int(offset))
            print(url)
            api.getListCharacters(urlString: url,
                                  method: .GET) { charactersList in
                DispatchQueue.main.async {
                    self.characters = charactersList
                    self.saveInCoreData(charactersList.data.results)
                    
                    if offset == 0 {
                        let dataPersisted = self.getDataFromCoreData()
                        self.carouselCharacters.append(contentsOf: dataPersisted.prefix(5))
                        self.listCharacters.append(contentsOf: dataPersisted.suffix(from: 5))
                        self.searchList = self.listCharacters
                        self.collectionViewCarousel.reloadData()
                        self.collectionViewCharactersList.reloadData()
                    } else {
                        self.list = self.getDataFromCoreData()
                        self.listCharacters.append(contentsOf: self.list.suffix(from: Int(offset)))
                        self.searchList.append(contentsOf: self.list.suffix(from: Int(offset)))
                        self.collectionViewCharactersList.reloadData()
                    }
                    
                    let newOffset = Int16(charactersList.data.offset + charactersList.data.count)
                    self.defineOffset(newOffset)
                    self.isLoading = false
                }
            } failure: { error in
                switch error {
                case .emptyArray:
                    self.showAlertToUser(message: "Não foi possível mostrar os Personagens")
                case .notFound:
                    self.showAlertToUser(message: "Dados dos Personagens não encontrados")
                default:
                    break;
                }
            }
        }
    }
    
    func defineOffset(_ offsetAPI: Int16) {
        let context = DataBaseController.persistentContainer.viewContext
        let entityOffset = EntityOffset(context: context)
        entityOffset.offset = offsetAPI
        DataBaseController.saveContext()
    }
    
    func getOffset() -> Int16 {
        var offset: Int16 = 0
        do {
            let result = try DataBaseController.persistentContainer.viewContext.fetch(EntityOffset.fetchRequest())
            let index = result.count
            if index > 0 {
                offset = result[index-1].offset
            }
        } catch {
            print("It was not possible to bring the offset information from the database.")
        }
        return offset
    }
    
    func saveInCoreData(_ models: [Result]) {
        for character in models {
            let context = DataBaseController.persistentContainer.viewContext
            let data = Hero(context: context)
            data.name = character.name
            let img = character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension
            
            if img != "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/standard_xlarge.jpg" {
                data.image = img
            } else {
                data.image = "https://cdn.awsli.com.br/300x300/344/344270/produto/35008083/0f1a15a752.jpg"
            }
            
            data.resultDescription = character.resultDescription
            
            var concatComics = ""
            var concatEvents = ""
            var concatSeries = ""
            
            for comicsItem in character.comics.items {
                concatComics += comicsItem.name + "\n"
            }
            
            for eventsItem in character.events.items {
                concatEvents += eventsItem.name + "\n"
            }
            
            for seriesItem in character.series.items {
                concatSeries += seriesItem.name + "\n"
            }
            
            data.comics = concatComics
            data.events = concatEvents
            data.series = concatSeries
            
            DataBaseController.saveContext()
        }
    }
    
    func getDataFromCoreData() -> [Hero] {
        do {
            let data = try DataBaseController.persistentContainer.viewContext.fetch(Hero.fetchRequest())
            return data
        } catch {
            print("It was not possible to bring the character information from the database")
            return []
        }
    }
    
    func getNumberOfCharactersInCoreData() -> Int16 {
        do {
            let data = try DataBaseController.persistentContainer.viewContext.fetch(Hero.fetchRequest())
            return Int16(data.count)
        } catch {
            print("It was not possible to bring the number of characters from the database.")
            return 0
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
        collectionViewCarousel.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        labelCharactersList.text = "MARVEL CHARACTERS LIST"
        labelCharactersList.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        collectionViewCharactersList.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        view.addSubview(labelFeaturedCharacters)
        view.addSubview(collectionViewCarousel)
        view.addSubview(labelCharactersList)
        view.addSubview(searchBar)
        view.addSubview(collectionViewCharactersList)
        setupConstraints()
    }
    
    private func showAlertToUser(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        let buttoRedoCall = UIAlertAction(title: "Tentar Novamente", style: .cancel) { _ in
            self.requestAPI()
        }
        let buttonCancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alert.addAction(buttoRedoCall)
        alert.addAction(buttonCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelFeaturedCharacters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelFeaturedCharacters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            collectionViewCarousel.topAnchor.constraint(equalTo: labelFeaturedCharacters.bottomAnchor, constant: 10),
            collectionViewCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionViewCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
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
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewCarousel {
            let character = self.carouselCharacters[indexPath.row]
            let details = DetailsViewController(character)
            navigationController?.pushViewController(details, animated: true)
        } else {
            let character = self.listCharacters[indexPath.row]
            let details = DetailsViewController(character)
            navigationController?.pushViewController(details, animated: true)
        }
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) && !isLoading {
            requestAPI()
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewCarousel {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCarousel {
            return carouselCharacters.count
        } else {
            if section == 0 {
                return listCharacters.count
            } else if section == 1 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCarousel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            let character = self.carouselCharacters[indexPath.row]
            cell.labelTitle.text = character.name
            
            if let imageURL = character.image {
                if let url = URL(string: imageURL) {
                    cell.imageCell.kf.setImage(with: url,
                                               options: [.cacheOriginalImage],
                                               completionHandler: { result in })
                }
            }
            
            return cell
        } else {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
                
                let character = listCharacters[indexPath.row]
                cell.labelTitle.text = character.name
                
                if let imageURL = character.image {
                    print(imageURL)
                    if let url = URL(string: imageURL) {
                        cell.imageCell.kf.setImage(with: url,
                                                   options: [.cacheOriginalImage],
                                                   completionHandler: { result in })
                    }
                }
                
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
            return CGSize(width: collectionView.bounds.width, height: 80)
        } else if collectionView == collectionViewCarousel {
            return CGSize(width: collectionView.bounds.height-10, height: collectionView.bounds.height-10)
        } else {
            return CGSize(width: ((collectionView.bounds.width/2)-15), height: 166.0)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            listCharacters = searchList.filter({ $0.name!.hasPrefix(searchText) })
            collectionViewCharactersList.reloadData()
        }
    }
    
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        let dataPersisted = getDataFromCoreData()
    //        self.listCharacters.append(contentsOf: dataPersisted.suffix(from: 5))
    //        collectionViewCharactersList.reloadData()
    //    }
    
}
