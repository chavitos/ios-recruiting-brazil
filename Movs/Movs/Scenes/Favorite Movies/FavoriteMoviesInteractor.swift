//
//  FavoriteMoviesInteractor.swift
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

protocol FavoriteMoviesBusinessLogic {
	func getFavoriteMovies(request: FavoriteMovies.GetFavoriteMovies.Request)
	func unfavoriteMovie(request: FavoriteMovies.UnfavoriteMovie.Request)
	func storeMovie(request: FavoriteMovies.ShowMovieDetail.Request)
}

protocol FavoriteMoviesDataStore {
	var movie:Movie? { get set }
}

class FavoriteMoviesInteractor: FavoriteMoviesBusinessLogic, FavoriteMoviesDataStore {
	
	var presenter: FavoriteMoviesPresentationLogic?
	var worker: FavoriteMoviesWorker?
	
	var movie:Movie?
	
	private var movies:[Movie] = []
	
	// MARK: - Get Favorite Movie
	
	func getFavoriteMovies(request: FavoriteMovies.GetFavoriteMovies.Request) {

		worker = FavoriteMoviesWorker(FavoriteMoviesCoredataWorker())
		worker?.getFavoriteMovies(completion: { (favoriteMovies, error) in
			
			var response:FavoriteMovies.GetFavoriteMovies.Response
			
			if error == nil {
				
				if let movies = favoriteMovies, movies.count > 0 {
					
					self.movies = movies
					
					response = FavoriteMovies.GetFavoriteMovies.Response(favoriteMovies: movies, error: nil)
				}else{
					
					response = FavoriteMovies.GetFavoriteMovies.Response(favoriteMovies: [], error: nil)
				}
			}else{
				
				response = FavoriteMovies.GetFavoriteMovies.Response(favoriteMovies:nil, error: error)
			}
			
			self.presenter?.presentFavoriteMovies(response: response)
		})
	}
	
	// MARK: - Unfavorite Movie
	
	func unfavoriteMovie(request: FavoriteMovies.UnfavoriteMovie.Request) {
		
		if let result = FavoriteMovie.getFavoriteMovies(withIds: [request.id]).1, result.count > 0, let favoriteMovie = result.first {
			
			if CoreDataManager.sharedInstance.deleteInCoreData(object: favoriteMovie) {
				getFavoriteMovies(request: FavoriteMovies.GetFavoriteMovies.Request())
			}
		}
	}
	
	// MARK: - Show Movie Detail
	
	func storeMovie(request: FavoriteMovies.ShowMovieDetail.Request) {
		
		self.movie = movies.filter { $0.id == request.movieId }.first
		
		let response = FavoriteMovies.ShowMovieDetail.Response()
		self.presenter?.presentMovieDetail(response: response)
	}
}
