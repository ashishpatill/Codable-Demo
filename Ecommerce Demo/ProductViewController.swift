//
//  ProductViewController.swift
//  Ecommerce Demo
//
//  Created by Ashish Pisey on 12/2/17.
//  Copyright © 2017 Ashish Pisey. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblProduct: UITableView!
    var arrProduct:[Product] = []
    var categoryName:String = ""
    var ranking:Ranking?
    var categoryProducts:[Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.categoryName
        let rightButtonItem = UIBarButtonItem.init(
            title: "Filter",
            style: .done,
            target: self,
            action: #selector(self.showActionSheet)
        )
        self.categoryProducts = self.arrProduct
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryProducts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell!.textLabel?.text = categoryProducts[indexPath.row].name
        cell?.selectionStyle = .none
        return cell!
    }
    
    @objc func showActionSheet()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Filter by", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheetController.addAction(cancelActionButton)

        let mostViewedAction = UIAlertAction(title: self.ranking?.viewedRanking.ranking, style: .default)
        { _ in
            self.sortBy(rankingType: RankingType.MostViewed)
        }
        
        actionSheetController.addAction(mostViewedAction)
        
        let mostOrderedAction = UIAlertAction(title: self.ranking?.orderedRanking.ranking, style: .default)
        { _ in
            self.sortBy(rankingType: RankingType.MostOrdered)
        }
        
        actionSheetController.addAction(mostOrderedAction)
        
        let mostSharedAction = UIAlertAction(title: self.ranking?.sharedRanking.ranking, style: .default)
        { _ in
            self.sortBy(rankingType: RankingType.MostShared)
        }
        
        actionSheetController.addAction(mostSharedAction)
        
        let defaultRankingAction = UIAlertAction(title: "Default", style: .default)
        { _ in
            self.sortBy(rankingType: RankingType.Default)
        }
        actionSheetController.addAction(defaultRankingAction)
        
        self.present(actionSheetController, animated: true, completion: nil)


    }
    
    func sortBy(rankingType:RankingType)
    {
        self.categoryProducts = self.arrProduct
        if rankingType == .Default
        {
            self.tblProduct.reloadData()
            return
        }
    
        // Sort Category
        var dictArr:[[String:Any]] = []
        if rankingType == .MostViewed
        {
            
            for rankedProduct:MostViewedProduct in (self.ranking?.viewedRanking.products)! {
                for categoryProduct:Product in self.categoryProducts
                {
                    if categoryProduct.id == rankedProduct.id
                    {
                        let dict = ["Products": categoryProduct,"counts":rankedProduct.view_count!] as! [String : Any]
                        dictArr.append(dict)
                    }
                }
                
            }
        }
        
        if rankingType == .MostOrdered
        {
            for rankedProduct:MostOrderedProduct in (self.ranking?.orderedRanking.products)! {
                for categoryProduct:Product in self.categoryProducts
                {
                    if categoryProduct.id == rankedProduct.id
                    {
                        let dict = ["Products": categoryProduct,"counts":rankedProduct.order_count!] as! [String : Any]
                        dictArr.append(dict)
                    }
                }
            }
        }
        
        if rankingType == .MostShared
        {
            for rankedProduct:MostSharedProduct in (self.ranking?.sharedRanking.products)! {
                for categoryProduct:Product in self.categoryProducts
                {
                    if categoryProduct.id == rankedProduct.id
                    {
                        let dict = ["Products": categoryProduct,"counts":rankedProduct.shares!] as! [String : Any]
                        dictArr.append(dict)
                    }
                }
            }
        }

        print(dictArr)
        
        dictArr = dictArr.sorted(by: { (first:[String:Any]!, second:[String:Any]!) -> Bool in
            let firstCount = first["counts"] as! Int
            let secCount = second["counts"] as! Int
            
            if (firstCount > secCount)
            {
                return true
            }
            return false
        })
        print(dictArr)
        
        var tempArray: [Product] = []
        for var dict in dictArr {
            tempArray.append(dict["Products"] as! Product)
        }
        categoryProducts = tempArray
        self.tblProduct.reloadData()
    }

}
