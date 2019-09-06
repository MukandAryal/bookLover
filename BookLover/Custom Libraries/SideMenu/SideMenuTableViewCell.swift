
import UIKit

class SideMenuTableViewCell: UITableViewCell {

  
    @IBOutlet weak var lblCount: UILabelFontSize!
    @IBOutlet weak var lblTitle: UILabelFontSize!
    @IBOutlet weak var imgIcon : UIImageView!

    func setData(dict:[String:AnyObject], indexPath:IndexPath) {
        
        imgIcon.image = UIImage(named: (dict["icon"] as? String)!)?.withRenderingMode(.alwaysTemplate)
        imgIcon.tintColor = UIColor.white

        lblTitle.text = dict["title"] as? String
        lblTitle.textColor = UIColor.white
        if indexPath.row == 3 {
            
            if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
                lblCount.layer.cornerRadius = lblCount.frame.size.height/2.0
                lblCount.clipsToBounds = true
                lblCount.isHidden = false
                lblCount.backgroundColor = appThemeColor
                lblCount.textColor = appBackGroundColor
                if appDelegateObj.userData["totalBooks"] != nil {
                    lblCount.text = " \(appDelegateObj.userData["totalBooks"] as! Int) "
                } else {
                    lblCount.text = " 0 "
                }
            } else {
                lblCount.isHidden = true
            }

            
        } else {
            lblCount.isHidden = true
        }
    }
}
