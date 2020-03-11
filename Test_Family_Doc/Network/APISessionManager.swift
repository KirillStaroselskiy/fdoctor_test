//
//  APISessionManager.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation

import Alamofire

class APISessionManager: Session {
    typealias DataResponseCompletionHandler = (_ data: AFDataResponse<Data>) -> Void

    func request(_ urlRequest: URLRequestConvertible, _ completionHandler: @escaping DataResponseCompletionHandler) -> Void {
        request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { response in
                completionHandler(response)
        }
    }
    
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, _ completionHandler: @escaping DataResponseCompletionHandler) -> Void {
        request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                completionHandler(response)
        }
    }

}
