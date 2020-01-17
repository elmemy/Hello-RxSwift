//
//  StockCell.swift
//  Hello RxSwift
//
//  Created by ahmed elmemy on 1/17/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa

class StockCell: UITableViewCell {

  // MARK: - Properties
  var bag = DisposeBag()

  // MARK: - IBOutlets
  @IBOutlet weak var stockSymbol: UILabel!
  @IBOutlet weak var currentPrice: UILabel!
  @IBOutlet weak var delta: UILabel!

  // MARK: - View Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()

    bag = DisposeBag()
  }
}

// MARK: - Internal
extension StockCell {

  func update(with price: StockPrice) {
    stockSymbol.text = price.isFavorite ? price.symbol + " 💖" : price.symbol
    
  }

  func flash() {
    contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.contentView.backgroundColor = UIColor.white
    }
  }
}
