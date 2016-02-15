//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zubair Khan on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filterCriteria: FilterCriteria)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String:String]]!

    var filterCriteria = FilterCriteria()

    var isDistanceMenuExpanded = false
    var isSortByMenuExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        var selectedCategories = [String]()
        for (row, isSelected) in filterCriteria.switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }

        /*
        let fc = FilterCriteria()
        if selectedCategories.count > 0 {
            fc.categories = selectedCategories
        }
        fc.dealSwitchState = filterCriteria.dealSwitchState
        fc.sortBy = filterCriteria.selectedSortByValue()
        fc.distance = filterCriteria.selectedDistanceValue()
        */
        filterCriteria.categories = selectedCategories
        filterCriteria.sortBy = filterCriteria.selectedSortByValue()
        filterCriteria.distance = filterCriteria.selectedDistanceValue()
        delegate?.filtersViewController(self, didUpdateFilters: filterCriteria)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return nil
            case 1:
                return "Distance"
            case 2:
                return "Sort By"
            case 3:
                return "Category"
            default:
                return nil
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return isDistanceMenuExpanded ? filterCriteria.distanceValuesText.count : 1
            case 2:
                return isSortByMenuExpanded ? filterCriteria.sortByValuesText.count : 1
            case 3:
                return categories.count
            default:
                return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let idx = indexPath.row
        switch indexPath.section {
            case 0:
                let cell = getSwitchCell(indexPath)
                cell.switchLabel.text = "Offering a Deal"
                cell.onSwitch.on = filterCriteria.dealSwitchState
                return cell
            case 1:
                let cell = getDropDownCell(indexPath)
                cell.titleLabel.text = isDistanceMenuExpanded ? filterCriteria.distanceText(idx) : filterCriteria.selectedDistanceText()
                return cell
            case 2:
                let cell = getDropDownCell(indexPath)
                cell.titleLabel.text = isSortByMenuExpanded ? filterCriteria.sortByText(idx) : filterCriteria.selectedSortByText()
                return cell
            case 3:
                let cell = getSwitchCell(indexPath)
                cell.switchLabel.text = categories[idx]["name"]
                cell.onSwitch.on = filterCriteria.switchStates[idx] ?? false
                return cell
            default:
                return getDropDownCell(indexPath)
        }
    }

    func getSwitchCell(indexPath: NSIndexPath) -> SwitchCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.delegate = self
        return cell
    }

    func getDropDownCell(indexPath: NSIndexPath) -> DropDownCell {
        return tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        if section == 1 {
            filterCriteria.selectedDistanceIdx = indexPath.row
            isDistanceMenuExpanded = !isDistanceMenuExpanded
            changeSectionRowCount(section, newCount: isDistanceMenuExpanded ? filterCriteria.distanceValuesText.count : 1)

        } else if indexPath.section == 2 {
            filterCriteria.selectedSortByIdx = indexPath.row
            isSortByMenuExpanded = !isSortByMenuExpanded
            changeSectionRowCount(section, newCount: isSortByMenuExpanded ? filterCriteria.sortByValuesText.count : 1)
        }
    }

    func changeSectionRowCount(section: Int, newCount: Int) {
        let oldCount = tableView.numberOfRowsInSection(section)

        let startIdx = min(oldCount, newCount)
        let endIdx = max(oldCount, newCount)

        var indexPaths = [NSIndexPath]()

        for var i = startIdx; i<endIdx; i++ {
            indexPaths.append(NSIndexPath.init(forRow: i, inSection: section))
        }

        tableView.beginUpdates()

        if oldCount > 0 {
            tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: section)], withRowAnimation: .Fade)
        }

        if newCount > oldCount {
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        } else {
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }

        tableView.endUpdates()
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        if indexPath.section == 0 {
            filterCriteria.dealSwitchState = value
        } else if indexPath.section == 3 {
            filterCriteria.switchStates[indexPath.row] = value
        }
    }

    func yelpCategories() -> [[String:String]] {
        return [["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "Senegalese", "code": "senegalese"],
            ["name": "South African", "code": "southafrican"],
            ["name": "American", "code": "New) (newamerican"],
            ["name": "American", "code": "Traditional) (tradamerican"],
            ["name": "Arabian", "code": "arabian"],
            ["name": "Argentine", "code": "argentine"],
            ["name": "Armenian", "code": "armenian"],
            ["name": "Asian Fusion", "code": "asianfusion"],
            ["name": "Australian", "code": "australian"],
            ["name": "Austrian", "code": "austrian"],
            ["name": "Bangladeshi", "code": "bangladeshi"],
            ["name": "Barbeque", "code": "bbq"],
            ["name": "Basque", "code": "basque"],
            ["name": "Belgian", "code": "belgian"],
            ["name": "Brasseries", "code": "brasseries"],
            ["name": "Brazilian", "code": "brazilian"],
            ["name": "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name": "British", "code": "british"],
            ["name": "Buffets", "code": "buffets"],
            ["name": "Burgers", "code": "burgers"],
            ["name": "Burmese", "code": "burmese"],
            ["name": "Cafes", "code": "cafes"],
            ["name": "Cafeteria", "code": "cafeteria"],
            ["name": "Cajun/Creole", "code": "cajun"],
            ["name": "Cambodian", "code": "cambodian"],
            ["name": "Caribbean", "code": "caribbean"],
            ["name": "Dominican", "code": "dominican"],
            ["name": "Haitian", "code": "haitian"],
            ["name": "Puerto Rican", "code": "puertorican"],
            ["name": "Trinidadian", "code": "trinidadian"],
            ["name": "Catalan", "code": "catalan"],
            ["name": "Cheesesteaks", "code": "cheesesteaks"],
            ["name": "Chicken Shop", "code": "chickenshop"],
            ["name": "Chicken Wings", "code": "chicken_wings"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "Cantonese", "code": "cantonese"],
            ["name": "Dim Sum", "code": "dimsum"],
            ["name": "Shanghainese", "code": "shanghainese"],
            ["name": "Szechuan", "code": "szechuan"],
            ["name": "Comfort Food", "code": "comfortfood"],
            ["name": "Creperies", "code": "creperies"],
            ["name": "Cuban", "code": "cuban"],
            ["name": "Czech", "code": "czech"],
            ["name": "Delis", "code": "delis"],
            ["name": "Diners", "code": "diners"],
            ["name": "Ethiopian", "code": "ethiopian"],
            ["name": "Fast Food", "code": "hotdogs"],
            ["name": "Filipino", "code": "filipino"],
            ["name": "Fish & Chips", "code": "fishnchips"],
            ["name": "Fondue", "code": "fondue"],
            ["name": "Food Court", "code": "food_court"],
            ["name": "Food Stands", "code": "foodstands"],
            ["name": "French", "code": "french"],
            ["name": "Gastropubs", "code": "gastropubs"],
            ["name": "German", "code": "german"],
            ["name": "Gluten-Free", "code": "gluten_free"],
            ["name": "Greek", "code": "greek"],
            ["name": "Halal", "code": "halal"],
            ["name": "Hawaiian", "code": "hawaiian"],
            ["name": "Himalayan/Nepalese", "code": "himalayan"],
            ["name": "Hot Dogs", "code": "hotdog"],
            ["name": "Hot Pot", "code": "hotpot"],
            ["name": "Hungarian", "code": "hungarian"],
            ["name": "Iberian", "code": "iberian"],
            ["name": "Indian", "code": "indpak"],
            ["name": "Indonesian", "code": "indonesian"],
            ["name": "Irish", "code": "irish"],
            ["name": "Italian", "code": "italian"],
            ["name": "Calabrian", "code": "calabrian"],
            ["name": "Sardinian", "code": "sardinian"],
            ["name": "Tuscan", "code": "tuscan"],
            ["name": "Japanese", "code": "japanese"],
            ["name": "Ramen", "code": "ramen"],
            ["name": "Teppanyaki", "code": "teppanyaki"],
            ["name": "Korean", "code": "korean"],
            ["name": "Kosher", "code": "kosher"],
            ["name": "Laotian", "code": "laotian"],
            ["name": "Latin American", "code": "latin"],
            ["name": "Colombian", "code": "colombian"],
            ["name": "Salvadoran", "code": "salvadoran"],
            ["name": "Venezuelan", "code": "venezuelan"],
            ["name": "Live/Raw Food", "code": "raw_food"],
            ["name": "Malaysian", "code": "malaysian"],
            ["name": "Mediterranean", "code": "mediterranean"],
            ["name": "Falafel", "code": "falafel"],
            ["name": "Mexican", "code": "mexican"],
            ["name": "Middle Eastern", "code": "mideastern"],
            ["name": "Egyptian", "code": "egyptian"],
            ["name": "Lebanese", "code": "lebanese"],
            ["name": "Modern European", "code": "modern_european"],
            ["name": "Mongolian", "code": "mongolian"],
            ["name": "Moroccan", "code": "moroccan"],
            ["name": "Pakistani", "code": "pakistani"],
            ["name": "Persian/Iranian", "code": "persian"],
            ["name": "Peruvian", "code": "peruvian"],
            ["name": "Pizza", "code": "pizza"],
            ["name": "Polish", "code": "polish"],
            ["name": "Portuguese", "code": "portuguese"],
            ["name": "Poutineries", "code": "poutineries"],
            ["name": "Russian", "code": "russian"],
            ["name": "Salad", "code": "salad"],
            ["name": "Sandwiches", "code": "sandwiches"],
            ["name": "Scandinavian", "code": "scandinavian"],
            ["name": "Scottish", "code": "scottish"],
            ["name": "Seafood", "code": "seafood"],
            ["name": "Singaporean", "code": "singaporean"],
            ["name": "Slovakian", "code": "slovakian"],
            ["name": "Soul Food", "code": "soulfood"],
            ["name": "Soup", "code": "soup"],
            ["name": "Southern", "code": "southern"],
            ["name": "Spanish", "code": "spanish"],
            ["name": "Sri Lankan", "code": "srilankan"],
            ["name": "Steakhouses", "code": "steak"],
            ["name": "Supper Clubs", "code": "supperclubs"],
            ["name": "Sushi Bars", "code": "sushi"],
            ["name": "Syrian", "code": "syrian"],
            ["name": "Taiwanese", "code": "taiwanese"],
            ["name": "Tapas Bars", "code": "tapas"],
            ["name": "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name": "Tex-Mex", "code": "tex-mex"],
            ["name": "Thai", "code": "thai"],
            ["name": "Turkish", "code": "turkish"],
            ["name": "Ukrainian", "code": "ukrainian"],
            ["name": "Uzbek", "code": "uzbek"],
            ["name": "Vegan", "code": "vegan"],
            ["name": "Vegetarian", "code": "vegetarian"],
            ["name": "Vietnamese", "code": "vietnamese"]]
    }

}
