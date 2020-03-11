//
//  URLContainer.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
struct URLContainer {
    static var baseUrl: String {
        return "https://cloud.fdoctor.ru/"
    }
    
    static var testTask: String { return baseUrl.appending("test_task/") }
}
