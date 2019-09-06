//
//  BlockPopUp.swift
//  
//
//  Created by ios 7 on 01/06/18.
//

import UIKit

class BlockPopUp: UIViewController {
    
    var nav: UINavigationController?
    var friendId: String?
    var isBlock : Bool?
    var callPopUpDismiss: BlockUserCompletion?
    @IBOutlet weak var btnReport: UIButtonFontSize!
    @IBOutlet weak var btnBlock: UIButtonFontSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnReport.setTitle(localizedTextFor(key: PrivacySettingText.ReportTitle.rawValue), for: .normal)
        btnBlock.setTitle(localizedTextFor(key: PrivacySettingText.BlockTitle.rawValue), for: .normal)

        if self.isBlock! {
            btnBlock.isHidden = true
        } else {
            btnBlock.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         self.dismiss(animated: true, completion:{
            self.callPopUpDismiss!(false, false)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionButtonBlock(_ sender: UIButton) {
        self.dismiss(animated: true, completion:{
           self.callPopUpDismiss!(true, true)
        })
    }
    
    @IBAction func actionButtonReport(_ sender: UIButton) {
        self.dismiss(animated: true, completion:{
            self.callPopUpDismiss!(true, false)
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
