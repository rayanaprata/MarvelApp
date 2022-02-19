//
//  HomeViewProtocol.swift
//  MarvelApp
//
//  Created by C94280a on 14/01/22.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func reloadCarousel()
    func reloadCharactersList()
    func hideEmptyStateMessage()
    func showEmptyStateMessageToUser(message: String)
    func showAlertToUser(message: String)
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func reloadCarousel() {
        DispatchQueue.main.async {
            self.collectionViewCarousel.reloadData()
        }
    }
    
    func reloadCharactersList() {
        DispatchQueue.main.async {
            self.collectionViewCharactersList.reloadData()
        }
    }
    
    func hideEmptyStateMessage() {
        emptyStateMessage.removeFromSuperview()
    }
    
    func showEmptyStateMessageToUser(message: String) {
        emptyStateMessage.text = message
        collectionViewCharactersList.addSubview(emptyStateMessage)
        emptyStateMessage.centerXAnchor.constraint(equalTo: collectionViewCharactersList.centerXAnchor).isActive = true
        emptyStateMessage.centerYAnchor.constraint(equalTo: collectionViewCharactersList.centerYAnchor).isActive = true
    }
    
    func showAlertToUser(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let buttoRedoCall = UIAlertAction(title: "Try again", style: .cancel) { _ in
            self.viewModel.loadData()
        }
        let buttonCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(buttoRedoCall)
        alert.addAction(buttonCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
