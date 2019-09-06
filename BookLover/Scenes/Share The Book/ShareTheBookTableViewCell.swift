
import UIKit

class ShareTheBookTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabelFontSize!
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInterface()
        // Initialization code
    }
    
    func setUpInterface() {
        userProfileBtn.layer.cornerRadius  = userProfileBtn.frame.size.height/2.0
        userProfileBtn.clipsToBounds = true
        userProfileBtn.layer.borderWidth = 1.0
        userProfileBtn.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
