//
//  Movie.swift
//  Movs
//
//  Created by Tiago Chaves on 12/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by Toledo's Swift Xcode Templates
//

import Foundation

struct Movie: Codable, Equatable, CustomStringConvertible {
	
    let title		: String?
	let poster		: String?
	let backdrop	: String?
	let date		: String?
	let genre_ids	: [Int]?
	let genres		: [Genre]?
	let overview	: String?
	let id			: Int?
	
    enum CodingKeys:String,CodingKey{
        
        case title
		case id
		case overview
		case genre_ids
		case genres
		case poster 	= "poster_path"
		case backdrop 	= "backdrop_path"
		case date 		= "release_date"
    }
	
    static func == (lhs: Movie, rhs: Movie) -> Bool {
		
		return lhs.title == rhs.title && lhs.id == rhs.id
    }

    var description: String {
        return "\(title ?? "-")"
    }
}
