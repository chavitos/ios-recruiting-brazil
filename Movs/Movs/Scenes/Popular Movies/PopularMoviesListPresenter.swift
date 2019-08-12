//
//  PopularMoviesListPresenter.swift
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

protocol PopularMoviesListPresentationLogic {
	func presentPopularMovies(response: PopularMoviesList.GetPopularMovies.Response)
}

class PopularMoviesListPresenter: PopularMoviesListPresentationLogic {
	
	weak var viewController: PopularMoviesListDisplayLogic?
	
	// MARK: Do something
	
	func presentPopularMovies(response: PopularMoviesList.GetPopularMovies.Response) {
		
		let viewModel = PopularMoviesList.GetPopularMovies.ViewModel()
		viewController?.displayPopularMovies(viewModel: viewModel)
	}
}
