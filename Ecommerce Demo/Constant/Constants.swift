//
//  Constants.swift
//  CategoriesDemo
//
//  Created by Ashish Pisey on 12/1/17.
//  Copyright © 2017 Ashish Pisey. All rights reserved.
//

import UIKit

enum enviromentType {
    case live
    case dev
}

var environment = enviromentType.dev
struct Constants {
    
   static let baseURL = "https://stark-spire-93433.herokuapp.com/"
   
   static let subURL = "json"
}

enum RankingType {
    case MostViewed
    case MostOrdered
    case MostShared
    case Default
}
