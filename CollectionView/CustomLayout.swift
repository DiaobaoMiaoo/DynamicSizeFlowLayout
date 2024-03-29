//
//  CustomLayout.swift
//  CollectionView
//
//  Created by Ke MA on 2019-09-11.
//  Copyright © 2019 kemin. All rights reserved.
//

import UIKit

protocol LayoutDelegate: class {
  func numberOfColumns() -> Int
  func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath:IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {

  // 1
  weak var delegate: LayoutDelegate?
  
  // 2
  fileprivate var cellPadding: CGFloat = 10.0
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    // 1
    guard cache.isEmpty,
      let collectionView = collectionView,
      let delegate = delegate else {
        return
    }
    
    // 2
    let columnWidth = contentWidth / CGFloat(delegate.numberOfColumns())
    var xOffset = [CGFloat]()
    for column in 0 ..< delegate.numberOfColumns() {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: delegate.numberOfColumns())
    
    // 3
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      
      // 4
      let itemHeight = delegate.collectionView(collectionView, heightForItemAtIndexPath: indexPath)
      let height = cellPadding * 2 + itemHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      // 5
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      // 6
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      
      column = column < (delegate.numberOfColumns() - 1) ? (column + 1) : 0
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }

  override func invalidateLayout() {
    super.invalidateLayout()
    cache.removeAll()
  }
}
