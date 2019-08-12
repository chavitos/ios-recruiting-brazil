//
//  PopularMoviesListWorker.swift
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

class PopularMoviesListWorker {
	
	var PopularMoviesListWorker:PopularMoviesListWorkerProtocol
	
	init(_ PopularMoviesListWorker:PopularMoviesListWorkerProtocol) {
		
		self.PopularMoviesListWorker = PopularMoviesListWorker
	}
	
	func getPopularMovies(_ page:Int, completion:@escaping(PopularMoviesResult?,Error?) -> Void) {

		PopularMoviesListWorker.getPopularMovies(page) { (movies: () throws -> PopularMoviesResult) in

			do{
				let movies = try movies()
				
				completion(movies,nil)
			}catch let error{
				
				completion(nil, error)
			}
		}
	}
}

protocol PopularMoviesListWorkerProtocol {
	func getPopularMovies(_ page:Int, completion:@escaping(() throws -> PopularMoviesResult) -> Void)
}
