//
//  StateViewController.swift
//  BookLover
//
//  Created by ios 7 on 16/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class StateViewController: UIViewController {

    @IBOutlet var tblState: UITableView!
    var callbackDismiss: StateCompletion?
    var arrStateList = [CompleteProfile.ViewModel.StateData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SceneTitleText.StateSceneTitle.rawValue
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.StateSceneTitle.rawValue) )
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionCross(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: { self.callbackDismiss!(nil) })
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

extension StateViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        cell.textLabel?.text = arrStateList[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: { self.callbackDismiss!(self.arrStateList[indexPath.row]) })
    }
    
}
