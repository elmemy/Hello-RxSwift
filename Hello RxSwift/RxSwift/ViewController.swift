//
//  ViewController.swift
//  Hello RxSwift
//
//  Created by ahmed elmemy on 1/17/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var favouriteSwitch:UISwitch!
    @IBOutlet weak var searchTerm:UITextField!
    
    fileprivate let bag = DisposeBag()
    
    //input
    fileprivate let allSymbols = ["RZW", "UDP", "MTT", "ZKQ", "IPK", "ÆQÜ"]
    fileprivate let allPrices = Variable<[StockPrice]>([])
    
    //output
    fileprivate let prices = Variable<[StockPrice]>([])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allPrices.value = allSymbols.enumerated().map{ index ,symbol in
            return StockPrice(symbol:symbol, favorite:index % 2 == 0)
        }
        
        //        prices.value = allPrices.value
        
        bindUI()
    }
    
    
}

extension ViewController
{
    func bindUI(){
        Observable.combineLatest(allPrices.asObservable()
            , favouriteSwitch.rx.isOn
            , searchTerm.rx.text,
              resultSelector: { cuttentPrices,onlyFavourite,search in
                //                print("\(cuttentPrices)","\(onlyFavourite)","\(search)")
                
                return cuttentPrices.filter { price -> Bool in
                    return self.shouldDisplayPrice(price: price, onlyFavorites: onlyFavourite, search: search)
                    
                }
        })
        .bind(to: prices)
        .addDisposableTo(bag)
        //        .subscribe()
        prices.asObservable()
            .subscribe(onNext:{ value in
                self.tableview.reloadData()
            })
        .addDisposableTo(bag)
    }
}


extension ViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as! StockCell
        let price = prices.value[indexPath.row]
        cell.update(with:price)
        return cell
    }
    
    // MARK: - Functions
    fileprivate func shouldDisplayPrice(price: StockPrice, onlyFavorites: Bool, search: String?) -> Bool {
        if onlyFavorites && !price.isFavorite {
            return false
        }
        if let search = search,
            !search.isEmpty,
            !price.symbol.contains(search) {
            return false
        }
        return true
    }
    
    fileprivate func update(prices: [StockPrice], with newPrices: [String: Double]) -> [StockPrice] {
        for (key, newPrice) in newPrices {
            if let stockPrice = prices.filter({ $0.symbol == key }).first {
                stockPrice.update(newPrice)
            }
        }
        return prices
    }
    
    
}
