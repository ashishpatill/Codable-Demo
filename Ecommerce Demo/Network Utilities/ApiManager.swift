//
//  ApiManager.swift
//  CategoriesDemo
//
//  Created by Ashish Pisey on 12/1/17.
//  Copyright © 2017 Ashish Pisey. All rights reserved.
//

import UIKit

class ApiManager: NSObject {
    
    static func getJSON(_ success: @escaping (_ categories: DataModel, _ ranking:Ranking) -> Void, failure: @escaping ( _ errorDescription:String)-> Void) {
        let urlStr = Constants.baseURL + Constants.subURL
        if let jsonURL = URL.init(string: urlStr) {
            
            let task = URLSession.shared.dataTask(with: jsonURL, completionHandler: { (data, response, error) in
                if let error = error {
                    // api connection error
                    failure(error.localizedDescription)
                } else {
                    if let usableData = data {
                        //print(usableData) //JSONSerialization
                        do {
                            let model = try JSONDecoder().decode(DataModel.self, from: usableData)
                            let response = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:[[String:Any?]]]
                            guard let rankings = response["rankings"]  else {
                                return
                            }
                            
                            // sort Ranking by view count, order count, share count
                            let viewedData = try JSONSerialization.data(withJSONObject: rankings[0], options: [])
                            var mostViwedRanking = try JSONDecoder().decode(ViewedRanking.self, from: viewedData)
                            mostViwedRanking = ApiManager().sortRankingsBy(RankingType.MostViewed, ranking: mostViwedRanking) as! ViewedRanking
                            
                            let orderedData = try JSONSerialization.data(withJSONObject: rankings[1], options: [])
                            var mostOrderedRanking = try JSONDecoder().decode(OrderedRanking.self, from: orderedData)
                            mostOrderedRanking = ApiManager().sortRankingsBy(RankingType.MostOrdered, ranking: mostOrderedRanking) as! OrderedRanking
                            
                            let sharedData = try JSONSerialization.data(withJSONObject: rankings[2], options: [])
                            var mostsharedRanking = try JSONDecoder().decode(SharedRanking.self, from: sharedData)
                            mostsharedRanking = ApiManager().sortRankingsBy(RankingType.MostShared, ranking: mostsharedRanking) as! SharedRanking
                            
                            let ranking:Ranking = Ranking(viewedRanking: mostViwedRanking, orderedRanking: mostOrderedRanking, sharedRanking: mostsharedRanking)
                            success(model,ranking)
                        }
                        catch {
                            // parsing error
                            failure(error.localizedDescription)
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    func sortRankingsBy(_ rankingType:RankingType, ranking:Any) -> Any
    {
        switch rankingType {
        case .MostViewed:
            var viewedRanking:ViewedRanking = ranking as! ViewedRanking
            viewedRanking.products = viewedRanking.products.sorted(by: { (first, second) -> Bool in
                if first.view_count! > second.view_count! {
                    return true
                }
                return false
            })
            return viewedRanking
        case .MostOrdered:
            var orderedRanking:OrderedRanking = ranking as! OrderedRanking
            orderedRanking.products = orderedRanking.products.sorted(by: { (first, second) -> Bool in
                if first.order_count! > second.order_count! {
                    return true
                }
                return false
            })
            return orderedRanking
        case .MostShared:
            var sharedRanking:SharedRanking = ranking as! SharedRanking

            sharedRanking.products = sharedRanking.products.sorted(by: { (first, second) -> Bool in
                if first.shares! > second.shares! {
                    return true
                }
                return false
            })
            return sharedRanking
        case .Default:
            return []
            
        }
    }
    
}
