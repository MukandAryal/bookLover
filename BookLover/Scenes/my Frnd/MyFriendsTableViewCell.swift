
import UIKit

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var lblUserName: UILabelFontSize!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnProfilePic.layer.cornerRadius = btnProfilePic.frame.size.height/2.0
        btnProfilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
