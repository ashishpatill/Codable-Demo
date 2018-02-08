//
//  ProductDetailViewController.swift
//  Ecommerce Demo
//
//  Created by Ashish Pisey on 12/3/17.
//  Copyright © 2017 Ashish Pisey. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
  var productDetail: Product?
  
  @IBOutlet weak var collectionProduct: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.title = productDetail?.name
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let array = productDetail?.variants
    {
      return array.count
    }
    else
    {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = "cell"
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    if let variantsArray = productDetail?.variants
    {
      print(variantsArray[indexPath.row].price ?? "")
    }
    return cell
  }
  
  
}

