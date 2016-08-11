//
//  Filters.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import Foundation

class Filters {
    var filters = [Filter]()
    init(){
//        for currentFilter in FilterType.allFilterTypes(){
//            filters.append(Filter(filterType: currentFilter))
//        }
//        filters.append(Filter(filterType: FilterType.Hue))
//        filters.append(Filter(filterType: FilterType.Purple))
        filters.append(Filter(filterType: FilterType.StarryNight))
        filters.append(Filter(filterType: FilterType.Neon))
        filters.append(Filter(filterType: FilterType.CrossPolynomial))
    }
}
