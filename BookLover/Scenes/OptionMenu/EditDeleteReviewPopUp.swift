//
//  EditDeleteReviewPopUp.swift
//  BookLover
//
//  Created by ios 7 on 01/06/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class EditDeleteReviewPopUp: UIViewController {

    var nav: UINavigationController?
    @IBOutlet weak var btnEdit: UIButtonFontSize!
    @IBOutlet weak var btnDelete: UIButtonFontSize!
    var callbackDismiss: DeleteReviewCompletion?

    var dictData: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnEdit.setTitle(localizedTextFor(key: GeneralText.editRow.rawValue), for: .normal)
        btnDelete.setTitle(localizedTextFor(key: GeneralText.deleteRow.rawValue), for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionButtonEdit(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion:{
            self.routeToRating()
        })
    }
    
    @IBAction func actionButtonDelete(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion:{
            self.callbackDismiss!(true)
        })
    }

    
    func routeToRating() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.Rating) as! RatingViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToRating(destination: &destinationDS, rating: (dictData!["rating"] as? Double)!, description: (dictData!["description"] as? String)!, bookId: (dictData!["bookId"] as? String)!)
        
        let navC = UINavigationController(rootViewController: destinationVC)
        let vc = CommonFunctions.sharedInstance.topViewController()
        vc?.present(navC, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToRating(destination: inout RatingDataStore, rating: Double, description: String, bookId:String)
    {
        destination.description = description
        destination.rating = rating
        destination.bookId = bookId
        destination.isRatingEdit = true
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
