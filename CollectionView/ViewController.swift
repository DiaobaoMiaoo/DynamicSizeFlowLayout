//
//  ViewController.swift
//  CollectionView
//
//  Created by Ke MA on 2019-09-11.
//  Copyright © 2019 kemin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
  }
  
  let cards = ["1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111", "2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222", "333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333"]
  
  private let spacing: CGFloat = 10.0
  
  private var width: CGFloat {
    let numberOfColumn = UIScreen.main.bounds.width >= 400 ? 3 : 2
    let width = collectionView.frame.width
    return (width - CGFloat(numberOfColumn + 1) * spacing) / CGFloat(numberOfColumn)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    if let layout = collectionView?.collectionViewLayout as? CustomLayout {
      layout.delegate = self
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cards.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! Card
    cell.label.text = cards[indexPath.row]
    return cell
  }
}

extension ViewController: LayoutDelegate {
  
  func numberOfColumns() -> Int {
    return UIScreen.main.bounds.width >= 400 ? 3 : 2
  }
  
  func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
    let label = UILabel()
    label.text = cards[indexPath.row]
    let size = label.systemLayoutSizeFitting(CGSize(width: width, height: 100.0), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .defaultHigh)
    
    return CGFloat(indexPath.row + 1) * 100
  }
}
