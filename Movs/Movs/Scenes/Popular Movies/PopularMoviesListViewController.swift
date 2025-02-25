//
//  PopularMoviesListViewController.swift
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
import NVActivityIndicatorView

protocol PopularMoviesListDisplayLogic: class {
	func displayPopularMovies(viewModel: PopularMoviesList.GetPopularMovies.ViewModel)
	func displayMovieDetail(viewModel: PopularMoviesList.ShowMovieDetail.ViewModel)
	func displayFilteredMovies(viewModel: PopularMoviesList.FilteredMovies.ViewModel)
	func displayFavoriteStatus(viewModel: PopularMoviesList.RefreshFavoriteStatus.ViewModel)
}

class PopularMoviesListViewController: UIViewController, PopularMoviesListDisplayLogic, NVActivityIndicatorViewable {
	
	var interactor: PopularMoviesListBusinessLogic?
	var router: (NSObjectProtocol & PopularMoviesListRoutingLogic & PopularMoviesListDataPassing)?
	
	// MARK: Object lifecycle
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
		setup()
	}
	
	// MARK: Setup
	
	private func setup() {
		
		let viewController = self
		let interactor = PopularMoviesListInteractor()
		let presenter = PopularMoviesListPresenter()
		let router = PopularMoviesListRouter()
		
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
	// MARK: Routing
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let scene = segue.identifier {
		
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		self.navigationController?.navigationBar.shadowImage = UIImage()
		
		getPopularMovies()
		getGenres()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		refreshFavoriteStatus()
	}
	
	// MARK: - Outlets & Vars
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	let cellIdentifier = "MovieCell"
	var movies:[MovieViewModel] = []
	var filteredMovies:[MovieViewModel] = []
	var nextPage = 1
	var filtering = false
	
	private func clearCollection() {
		
		filteredMovies = []
		
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	// MARK: - Get Popular Movies
	
	private func getPopularMovies() {
		
		if nextPage > 0 {
			
			let size = CGSize(width: 30, height: 30)
			startAnimating(size, message: "Fetching movies...", type: .ballRotateChase, fadeInAnimation: nil)
			
			let request = PopularMoviesList.GetPopularMovies.Request(page: nextPage)
			interactor?.getPopularMovies(request: request)
		}
	}
	
	func displayPopularMovies(viewModel: PopularMoviesList.GetPopularMovies.ViewModel) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			self.stopAnimating(nil)
		}
		
		if viewModel.error == nil, let movies = viewModel.movies {
			
			if viewModel.hasNextPage {
				nextPage += 1
			}else{
				nextPage = 0
			}
			
			self.movies += movies
			
			refreshFavoriteStatus()
		}else{
			
			let errorView = ErrorView(forView: collectionView, withMessage: "An error ocurred. Please, try again.")
			
			DispatchQueue.main.async {
				self.collectionView.backgroundView = errorView
			}
		}
	}
	
	// MARK: - Show Movie Detail
	
	func displayMovieDetail(viewModel: PopularMoviesList.ShowMovieDetail.ViewModel) {
		
		self.performSegue(withIdentifier: "MovieDetail", sender: nil)
	}
	
	// MARK: - Get Genres
	
	private func getGenres() {
		
		let request = PopularMoviesList.GetGenresList.Request()
		self.interactor?.getGenres(request: request)
	}
	
	// MARK: - Filter
	
	private func getFilteredMovies(withName name:String) {
		
		let request = PopularMoviesList.FilteredMovies.Request(text:name, popularMovies: movies)
		interactor?.getFilteredMovies(request: request)
	}
	
	func displayFilteredMovies(viewModel: PopularMoviesList.FilteredMovies.ViewModel) {
		
		filteredMovies = viewModel.filteredMovies
		filtering = true
		
		if filteredMovies.count > 0 {
			
			DispatchQueue.main.async {
				
				self.collectionView.backgroundView = nil
				self.collectionView.reloadData()
			}
		}else{
			
			clearCollection()
			
			let notFoundView = NotFoundView(forView: collectionView, withMessage: "Your search by \"\(viewModel.text)\" didn't return any movie.")
			
			DispatchQueue.main.async {
				self.collectionView.backgroundView = notFoundView
			}
		}
	}
	
	// MARK: - Refresh Favorite Status
	
	private func refreshFavoriteStatus() {
		
		interactor?.getFavoritedMovies(request: PopularMoviesList.RefreshFavoriteStatus.Request(movies: movies))
	}
	
	func displayFavoriteStatus(viewModel: PopularMoviesList.RefreshFavoriteStatus.ViewModel) {
		
		self.movies = viewModel.movies
		
		DispatchQueue.main.async {
			self.collectionView.backgroundView = nil
			self.collectionView.reloadData()
		}
	}
}

extension PopularMoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filtering ? filteredMovies.count : movies.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let movie = filtering ? filteredMovies[indexPath.row] : movies[indexPath.row]
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieCollectionViewCell {
			
			cell.config(withMovie: movie)			
			return cell
		}
		
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath)
		cell?.isSelected = false
		
		let movie = filtering ? filteredMovies[indexPath.row] : movies[indexPath.row]
		
		let request = PopularMoviesList.ShowMovieDetail.Request(movieId: movie.id)
		self.interactor?.storeMovie(request: request)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if !filtering {
			
			if indexPath.row == movies.count - 1 {
				
				getPopularMovies()
			}
		}
	}
}

extension PopularMoviesListViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if !searchText.isEmpty {
			getFilteredMovies(withName: searchText)
		}else{
			filtering = false
			collectionView.reloadData()
		}
	}
}
