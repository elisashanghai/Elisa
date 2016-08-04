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
        for currentFilter in FilterType.allFilterTypes(){
            filters.append(Filter(filterType: currentFilter))
        }
    }
}
