//
//  PopularMoviesListModels.swift
//  Movs
//
//  Created by Tiago Chaves on 11/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PopularMoviesList {
	
	// MARK: Get popular movies
	
	enum GetPopularMovies {
		
		struct Request {
			let page:Int
		}
		
		struct Response {
			let movies:[Movie]?
			let hasNextPage:Bool
			let error:Error?
		}
		
		struct ViewModel {
			let movies:[MovieViewModel]?
			let hasNextPage:Bool
			let error:Error?
		}
	}
	
	// MARK: Show Movie Detail
	
	enum ShowMovieDetail {
		
		struct Request {
			let movieId: Int?
		}
		
		struct Response {
			
			
		}
		
		struct ViewModel {
			
		}
	}
	
	// MARK: Get Genre List
	
	enum GetGenresList{
		
		struct Request
		{
			
		}
		struct Response
		{
			var genres:GenresResult
		}
		struct ViewModel
		{
			
		}
	}
}

struct MovieViewModel {
	
	let id			:Int?
	let title		:String?
	let posterUrl	:String?
}
