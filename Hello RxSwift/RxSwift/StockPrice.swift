//
//  StockPrice.swift
//  Hello RxSwift
//
//  Created by ahmed elmemy on 1/17/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//


import Foundation
import RxSwift

class StockPrice {

  // MARK: - Properties
  public let symbol: String
  public var isFavorite: Bool = false

  private let price = Variable<Double>(0)
  var priceObservable: Observable<Double> {
    return price.asObservable()
  }

  // MARK: - Initializers
  init(symbol: String, favorite: Bool) {
    self.symbol = symbol
    self.isFavorite = favorite
  }

  func update(_ price: Double) {
    self.price.value = price
  }
}
