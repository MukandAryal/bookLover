//
//  AgeSelectViewController.swift
//  BookLover
//
//  Created by Mss Mukunda on 21/06/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

protocol getAgeData {
    func setAgData(_ obj: [String: Any])
}

class AgeSelectViewController: UIViewController {
    
    let ArrAge = [
        "8-16",
        "13-18",
        "18-25",
        "25-35",
        "35-45",
        "45-55",
        "55-65",
        "65-75",
        "75+"
    ]
    var isSelected : Int = 0
    var ageArray = [Int]()
    
    @IBOutlet weak var tblAgeFilter: UITableView!
    
    var delegate: getAgeData?
    var filtersObj: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.AgeSelectTitle.rawValue))
    }
    
    func navigateToFilterScreen(age:[Int]){
        let ageObj = ["age":age] as [String : Any]
        delegate?.setAgData(ageObj)
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BtnCross(_ sender: Any) {
        self.dismiss(animated: true, completion: {
           // self.callbackDismiss!(nil)
        })
    }
}

// MARK: UITableViewDataSource --
extension AgeSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrAge.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        cell.textLabel?.text = ArrAge[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == ArrAge.count - 1 {
            ageArray = [75 ,120]
        }else {
            var strAge = ArrAge[indexPath.row]
            strAge = strAge.replacingOccurrences(of: "-", with: ",")
            let startAgeArray = strAge.components(separatedBy:",")
            let startAge = Int(startAgeArray[0])
            let endAgeArray = strAge.components(separatedBy:",")
            let endAge = Int(endAgeArray[1])
            ageArray = [startAge!, endAge!]
        }
        tblAgeFilter.reloadData()
        printToConsole(item: ageArray)
        navigateToFilterScreen(age: ageArray)
    }
    
}

