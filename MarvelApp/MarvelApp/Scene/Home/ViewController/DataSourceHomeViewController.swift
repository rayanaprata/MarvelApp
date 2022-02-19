//
//  DataSourceHomeViewController.swift
//  MarvelApp
//
//  Created by C94280a on 14/01/22.
//

import UIKit

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
            return viewModel.carouselCharacters.count
        } else {
            if section == 0 {
                return viewModel.listCharacters.count
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
            
            let character = viewModel.carouselCharacters[indexPath.row]
            cell.labelTitle.text = character.name
            
            cell.mainStackView.accessibilityHint = "Character \(indexPath.row+1) of \(viewModel.carouselCharacters.count)"
                        
            if character.thumbnail.getUrlImage() == viewModel.urlImageNotAvailable {
                cell.imageCell.image = UIImage(named: "deadpool.jpg")
            } else {
                if let url = URL(string: character.thumbnail.getUrlImage()) {
                    cell.imageCell.kf.setImage(with: url,
                                               options: [.cacheOriginalImage],
                                               completionHandler: { result in })
                }
            }
            
            return cell
        } else {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
                
                let character = viewModel.listCharacters[indexPath.row]
                cell.labelTitle.text = character.name
    
                cell.mainStackView.accessibilityHint = "Character \(indexPath.row+1) of \(viewModel.listCharacters.count)"
                
                if character.thumbnail.getUrlImage() == viewModel.urlImageNotAvailable {
                    cell.imageCell.image = UIImage(named: "deadpool.jpg")
                } else {
                    if let url = URL(string: character.thumbnail.getUrlImage()) {
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

