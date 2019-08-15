//
//  NetworkManager.swift
//  Movs
//
//  Created by Tiago Chaves on 12/08/19.
//  Copyright (c) 2019 Tiago Chaves. All rights reserved.
//
//  This file was generated by Toledo's Swift Xcode Templates
//

import Foundation
import Alamofire

enum MovsRequests: URLRequestConvertible {

    static let baseURLPath 				= "https://api.themoviedb.org"
    static let baseURI                  = "/3"
    static let completeURL              = "\(MovsRequests.baseURLPath)\(MovsRequests.baseURI)"
	
    case popularMovies(Int)
	case genres
    
    private var method: HTTPMethod {
        switch self {
        case .popularMovies, .genres:
            return .get
        }
    }
    
    private var baseURL: String{
        switch self{
        case .popularMovies, .genres:
            return MovsRequests.completeURL
        }
    }
    
    private var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
		case .genres:
			return "/genre/movie/list"
        }
    }
    
    private var parameters: [String: Any]? {
        switch self {
		case .popularMovies(let page):
			return ["api_key": apiKey,"language":"en-US","page":page]
		case .genres:
			return ["api_key": apiKey,"language":"en-US"]
        }
    }
    
    private var headers:HTTPHeaders {
        switch self {
        case .popularMovies, .genres:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

final class NetworkManager {
    
    static func request(withURL url:URLRequestConvertible, callback:@escaping (Data?,DataResponse<Any>?,Error?)->Void) {
        
        Alamofire.request(url).validate().responseJSON { response in
            
            NSLog("Requesting: \(url.urlRequest!)")
            switch response.result {
            case .success:
                let data = response.data
                NSLog("Request successed!")
                callback(data,response, nil)
            case .failure(let error):
                NSLog("Request failed! \(error.localizedDescription)")
                callback(nil,response, error)
            }
        }
    }
}
