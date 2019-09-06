//
//  BookShelvesViewController.swift
//  BookLover
//
//  Created by ios 7 on 23/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class BookShelvesViewController: UIViewController {
    
    @IBOutlet weak var btnCros: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBookName: UILabelFontSize!
    
    
    @IBOutlet weak var btnRead: UIButton!
    @IBOutlet weak var btnWantToRead: UIButton!
    @IBOutlet weak var btnReading: UIButton!
    
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var imgRead: UIImageView!
    @IBOutlet weak var imgReading: UIImageView!
    @IBOutlet weak var imgWantToRead: UIImageView!
    
    @IBOutlet weak var btnSubmit: UIButtonFontSize!
    
    var dictShelfData: [String:Any]?
    var callHomeDismiss: BookPopUpCompletion?
    var callDetailDismiss: DetailBookShelfPopUp?
    var callMyBookDismiss: MyBookShelfPopUp?
    var bookStatus: Int?
    var selectedStatus: Int!
    
    //    var is_Favourite: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIDesign()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if dictShelfData!["isFrom"] as! String == "Home" {
            self.callHomeDismiss!(false, nil)
        } else if dictShelfData!["isFrom"] as! String == "MyBooks" {
            let oldStatus = self.dictShelfData!["shelf_status"] as! Int
            self.callMyBookDismiss!(3, oldStatus)
        } else if dictShelfData!["isFrom"] as! String == "" {
            return
        }else {
            self.callDetailDismiss!(3)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Action --
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionRead(_ sender: UIButton) {
        setImageForStatus(status: 2)
        
    }
    
    @IBAction func actionWantToRead(_ sender: UIButton) {
        setImageForStatus(status: 0)
        
    }
    
    @IBAction func actionReading(_ sender: UIButton) {
        setImageForStatus(status: 1)
    }
    
    @IBAction func actionSubmit(_ sender: UIButtonFontSize) {

        if selectedStatus >= 3 {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BookPopUpValidation.AddStatus.rawValue))
        } else {
            let param : [String : Any] = [
                "user_id": CommonFunctions.sharedInstance.getUserId(),
                "book_id": "\((dictShelfData!["book_id"] as? Int)!)",
                "is_favourite": (dictShelfData!["is_favourite"] as? Bool)!,
                "shelf_status": selectedStatus.description]
                
            printToConsole(item: param)
            
            CommonFunctions.sharedInstance.hitBookShelfApi(withData: param) { (response) in
                
                if response.code == SuccessCode {
                    let data = response.result as! NSDictionary
                    self.dismiss(animated: true, completion: {
                        CustomAlertController.sharedInstance.showSuccessAlert(success: (data["result"] as? String)!)
                        
                        if self.dictShelfData!["isFrom"] as! String == "Home"{
                            
                            if self.selectedStatus == 2 {
//                                if self.selectedStatus == self.bookStatus {
//                                    self.callHomeDismiss!(false, nil)
//                                } else {
                                    self.callHomeDismiss!(true, "\((self.dictShelfData!["book_id"] as? Int)!)")
                                //}
                            }
                            else {
                                self.callHomeDismiss!(false, nil)
                            }
                        }
                        else if self.dictShelfData!["isFrom"] as! String == "MyBooks" {
                           // printToConsole(item: self.dictShelfData)
                            let oldStatus = self.dictShelfData!["shelf_status"] as! Int
                            self.callMyBookDismiss!(self.selectedStatus, oldStatus)
                        }
                        else if self.dictShelfData!["isFrom"] as! String == "" {
                            return
                        }
                        else {
                            self.callDetailDismiss!(self.selectedStatus)
                        }
                    })
                } else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            }
        }
    }
    
    // MARK: - Class Helper --
    
    func setUIDesign() {
        
        lblTitle.text = localizedTextFor(key: BookPopUpText.BookShelvesTitle.rawValue)
        
        btnRead.setTitle(localizedTextFor(key: BookPopUpText.Read.rawValue), for: .normal)
        btnReading.setTitle(localizedTextFor(key: BookPopUpText.Reading.rawValue), for: .normal)
        btnWantToRead.setTitle(localizedTextFor(key: BookPopUpText.WantToRead.rawValue), for: .normal)
        
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2.0
        btnSubmit.setTitle(localizedTextFor(key: OnBoardingModuleText.SubmitButtonTitle.rawValue), for: .normal)
        bookStatus = (dictShelfData?["shelf_status"] as? Int)!
        printToConsole(item: bookStatus)
        setImageForStatus(status: (dictShelfData?["shelf_status"] as? Int)!)
        lblBookName.text = dictShelfData?["name"] as? String
        
        let strImg = (dictShelfData?["cover_photo"] as? String)!
        imgBook.sd_setImage(with: URL(string: strImg), placeholderImage: UIImage(named: "defaultBookImage"))
        
    }
    
    func setImageForStatus(status:Int) {
        
        selectedStatus = status
        printToConsole(item: selectedStatus)
        switch status {
        case 0:
            imgRead.image = UIImage(named: "radio_inactive")
            imgReading.image = UIImage(named: "radio_inactive")
            imgWantToRead.image = UIImage(named: "radio_active")
            break
        case 1:
            imgRead.image = UIImage(named: "radio_inactive")
            imgReading.image = UIImage(named: "radio_active")
            imgWantToRead.image = UIImage(named: "radio_inactive")
            break
        case 2:
            imgRead.image = UIImage(named: "radio_active")
            imgReading.image = UIImage(named: "radio_inactive")
            imgWantToRead.image = UIImage(named: "radio_inactive")
            break
        default:
            imgRead.image = UIImage(named: "radio_inactive")
            imgReading.image = UIImage(named: "radio_inactive")
            imgWantToRead.image = UIImage(named: "radio_inactive")
            break
            
        }
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
