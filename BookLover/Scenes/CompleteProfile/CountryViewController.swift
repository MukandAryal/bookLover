//
//  CountryViewController.swift
//  BookLover
//
//  Created by ios 7 on 16/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    var arrCountryList = [[String:Any]]()
    var callbackDismiss: CountryCompletion?

    @IBOutlet var tblCountry: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let object = UserDefaults.standard.object(forKey: userDefualtKeys.countryList.rawValue) {
            let data = NSKeyedUnarchiver.unarchiveObject(with: object as! Data)
            arrCountryList = data as! [[String:Any]]
        }
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.CountrySceneTitle.rawValue))
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionCross(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: {
             self.callbackDismiss!(nil)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        cell.textLabel?.text = arrCountryList[indexPath.row]["name"] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: {
            self.callbackDismiss!(self.arrCountryList[indexPath.row])
        })
    }
    
}

