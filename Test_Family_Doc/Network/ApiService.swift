//
//  ApiService.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
import Alamofire


typealias PillsCompletionHandler = (_ pills: [PillsModel]?, _ error: Error?) -> Void

protocol APIServiceProtocol {
    func getPills( _ completionHandler: @escaping PillsCompletionHandler )
}

class APIService {
    var manager = APISessionManager()
    
    init() {
        manager.session.configuration.timeoutIntervalForRequest = 30.0
    }
}

extension APIService {
    // MARK:  - Загрузка данных
    func getPills( _ completionHandler: @escaping PillsCompletionHandler ) {
        guard let url = URL(string: URLContainer.testTask) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        manager.request(urlRequest) { response in
            
             DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        
                        switch response.result {
                        case .success(let data):
                            

                                let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                                var replaced = String(string1.map {
                                    $0 == "'" ? "\"" : $0
                                })
                                
                                replaced = replaced.replacingOccurrences(of:"status:", with: "\"status\":")
                                replaced = replaced.replacingOccurrences(of:"pills:", with: "\"pills\":")
                                replaced = replaced.replacingOccurrences(of:"id:", with: "\"id\":")
                                replaced = replaced.replacingOccurrences(of:"name:", with: "\"name\":")
                                replaced = replaced.replacingOccurrences(of:"img:", with: "\"img\":")
                                replaced = replaced.replacingOccurrences(of:"desription:", with: "\"desription\":")
                                replaced = replaced.replacingOccurrences(of:"dose:", with: "\"dose\":")
                                replaced = replaced.replacingOccurrences(of:"\n", with: ",\n")
                                replaced = replaced.replacingOccurrences(of:"{,", with: "{")
                                replaced = replaced.replacingOccurrences(of:", ,", with: ",")
                                replaced = replaced.replacingOccurrences(of:"[,", with: "[")
                                replaced = replaced.replacingOccurrences(of:",,", with: ",")


                                let newData = replaced.data(using: .utf8)!

                            guard let decodedData = PillsModelWrapper.decodeFromData(data: newData) else {
                                print("getPills: Не удалось распарсить объект")
                                return
                            }
            
                                completionHandler(decodedData.pills , nil)
                            
                        case .failure(let error):
                            completionHandler(nil, error)
                        }
         }
    }
}
