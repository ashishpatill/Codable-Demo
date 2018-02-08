//
//  ViewController.swift
//  Ecommerce Demo
//
//  Created by Ashish Pisey on 12/2/17.
//  Copyright © 2017 Ashish Pisey. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories : [ProductCategory] = []
    var ranks : Ranking?
    
    @IBOutlet weak var tblCategories: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.tag = 101
        if !activityIndicator.isDescendant(of: self.view)
        {
            self.view.addSubview(activityIndicator)
        }
        ApiManager.getJSON({ (model,ranking) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
            self.categories = model.categories
            
            self.ranks = ranking
            DispatchQueue.main.async {
                self.tblCategories.reloadData()
            }
        }) { (errorDescription) in
            print(errorDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = .none
        cell!.textLabel?.text = self.categories[indexPath.row].name
        return cell!
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let productVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductViewController
        productVC.categoryName = self.categories[indexPath.row].name
        productVC.arrProduct = self.categories[indexPath.row].products
        productVC.ranking = self.ranks
        
        self.navigationController?.pushViewController(productVC, animated: true)
        
    }

    


}

