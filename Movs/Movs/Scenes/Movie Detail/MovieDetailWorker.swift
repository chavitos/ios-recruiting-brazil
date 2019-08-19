//
//  MovieDetailWorker.swift
//  Movs
//
//  Created by Tiago Chaves on 14/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class MovieDetailWorker {
	
	var movieDetailWorker:MovieDetailWorkerProtocol
	
	init(_ movieDetailWorker:MovieDetailWorkerProtocol) {
		
		self.movieDetailWorker = movieDetailWorker
	}
	
//	func getData(completion:@escaping(ReturnData?,Error?) -> Void) {
//
//		MovieDetailWorker.getData { (data: () throws -> ReturnData) in
//
//			do{
//				let returnData = try data()
//				completion(returnData,nil)
//			}catch let error{
//				completion(nil, error)
//			}
//		}
//	}
}

protocol MovieDetailWorkerProtocol {
//	func getData(completion:@escaping(() throws -> ReturnData) -> Void)
}
