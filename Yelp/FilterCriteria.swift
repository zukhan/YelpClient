//
//  FilterCriteria.swift
//  Yelp
//
//  Created by Zubair Khan on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterCriteria: NSObject {
    var categories = [String]()
    var switchStates = [Int:Bool]()
    var dealSwitchState = false
    var distance: Double?
    var sortBy: YelpSortMode?

    let distanceValuesText = ["Auto", "0.3 miles", "1 mile", "3 miles", "5 miles", "20 miles"]
    let sortByValuesText = ["Best Match", "Distance", "Highest Rated"]

    let distanceValues = [-1, 0.3, 1, 3, 5, 20]
    let sortByValues: [YelpSortMode] = [.BestMatched, .Distance, .HighestRated]

    var selectedDistanceIdx = 0
    var selectedSortByIdx = 0

    init(categories: [String] = [], dealSwitchState: Bool = false) {
        self.categories = categories
        self.dealSwitchState = dealSwitchState
    }

    func distanceValue(idx: Int) -> Double? {
        return idx != 0 ? distanceValues[idx] : nil
    }

    func distanceText(idx: Int) -> String {
        return distanceValuesText[idx]
    }

    func sortByValue(idx: Int) -> YelpSortMode {
        return sortByValues[idx]
    }

    func sortByText(idx: Int) -> String {
        return sortByValuesText[idx]
    }

    func selectedDistanceValue() -> Double? {
        return distanceValue(selectedDistanceIdx)
    }

    func selectedSortByValue() -> YelpSortMode {
        return sortByValue(selectedSortByIdx)
    }

    func selectedDistanceText() -> String {
        return distanceText(selectedDistanceIdx)
    }

    func selectedSortByText() -> String {
        return sortByText(selectedSortByIdx)
    }

}
