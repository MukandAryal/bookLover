

import UIKit
import Cosmos

class UserReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrDD: UIImageView!
    @IBOutlet weak var userprofileBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabelFontSize!
    @IBOutlet weak var userDescriptionLbl: UILabelFontSize!
    @IBOutlet weak var btnAddComment: UIButtonFontSize!

    @IBOutlet weak var userDateLbl: UIButtonFontSize!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var userLikeBtn: UIButton!
    @IBOutlet weak var userCommntBtn: UIButton!
    @IBOutlet weak var commentsLbl: UILabelFontSize!
    @IBOutlet weak var commentUserProfileBtn: UIButton!
    @IBOutlet weak var commentUserNameLbl: UILabelFontSize!
    @IBOutlet weak var commentUserDateLbl: UILabelFontSize!
    @IBOutlet weak var commentUserCommentLbl: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if self.reuseIdentifier == ViewControllerIds.UserReviewCellIdentifier {
            commentUserProfileBtn.layer.cornerRadius = commentUserProfileBtn.frame.size.height/2.0
            commentUserProfileBtn.clipsToBounds = true
        } else {
            userRatingView.settings.fillMode = .full
            userprofileBtn.layer.cornerRadius = userprofileBtn.frame.size.height/2.0
            userprofileBtn.clipsToBounds = true
            btnAddComment.layer.cornerRadius = btnAddComment.frame.size.height/2.0
            btnAddComment.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
