//
//  ImageWithBlur.swift
//  MarvelApp
//
//  Created by C94280a on 25/11/21.
//

import Foundation
import UIKit

class ImageWithBlur: UIImageView {
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.8).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 1.5)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 0.0)
        self.layer.addSublayer(gradientLayer)
    }
}
