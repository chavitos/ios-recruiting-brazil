//
//  FavoriteMoviesCoredataWorker.swift
//  Movs
//
//  Created by Tiago Chaves on 15/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by Toledo's Swift Xcode Templates
//

import UIKit

class FavoriteMoviesCoredataWorker:FavoriteMoviesWorkerProtocol {
	
	func getFavoriteMovies(completion: @escaping (() throws -> [Movie]) -> Void) {
		
		let result = FavoriteMovie.getFavoriteMovies()
			
		if let favoriteMovies = result.0 {
			
			completion { return favoriteMovies }
		}else if let error = result.2 {
			
			completion { throw error }
		}
	}
}
