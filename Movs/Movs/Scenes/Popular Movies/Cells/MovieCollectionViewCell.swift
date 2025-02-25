//
//  MovieCollectionViewCell.swift
//  Movs
//
//  Created by Tiago Chaves on 11/08/19.
//  Copyright © 2019 Tiago Chaves. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var favoriteView: UIView!
	
	let imageUrl = "https://image.tmdb.org/t/p/w500"
	
	override func prepareForReuse() {
		posterImageView.image = nil
		titleLabel.text = ""
		favoriteView.isHidden = true
	}
	
	func config(withMovie movie:MovieViewModel) {
		
		titleLabel.text = movie.title ?? "-"
		
		if let posterUrl = movie.posterUrl {
			
			let completePosterUrl = "\(imageUrl)\(posterUrl)"
			posterImageView.setImage(withUrl: completePosterUrl)
		}
		
		if movie.favoriteStatus == true {
			favoriteView.isHidden = false
		}
	}
}
