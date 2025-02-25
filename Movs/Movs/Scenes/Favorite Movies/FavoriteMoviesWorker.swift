//
//  FavoriteMoviesWorker.swift
//  Movs
//
//  Created by Tiago Chaves on 15/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class FavoriteMoviesWorker {
	
	var favoriteMoviesWorker:FavoriteMoviesWorkerProtocol
	
	init(_ favoriteMoviesWorker:FavoriteMoviesWorkerProtocol) {
		
		self.favoriteMoviesWorker = favoriteMoviesWorker
	}
	
	func getFavoriteMovies(completion:@escaping([Movie]?,Error?) -> Void) {

		favoriteMoviesWorker.getFavoriteMovies { (data: () throws -> [Movie]) in

			do{
				let returnData = try data()
				completion(returnData,nil)
			}catch let error{
				completion(nil, error)
			}
		}
	}
}

protocol FavoriteMoviesWorkerProtocol {
	func getFavoriteMovies(completion:@escaping(() throws -> [Movie]) -> Void)
}
