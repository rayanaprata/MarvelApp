//
//  DelegateHomeViewController.swift
//  MarvelApp
//
//  Created by C94280a on 14/01/22.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character: Result
        
        if collectionView == collectionViewCarousel {
            character = viewModel.carouselCharacters[indexPath.row]
        } else {
            character = viewModel.listCharacters[indexPath.row]
        }
        
        let replacedName = character.name.replaceSpacesAndUnaccent
        tag.selectContent(replacedName: replacedName)
        
        let detailsViewModel = DetailsViewModel(character: character)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) && !viewModel.isLoading {
            viewModel.validateInternetConnection()
            viewModel.getCharacters()
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.hideEmptyStateMessage()
            viewModel.listCharacters = viewModel.list
            collectionViewCharactersList.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let startsWith = searchBar.text else {return}
        viewModel.getSearchCharacters(startsWith)
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
