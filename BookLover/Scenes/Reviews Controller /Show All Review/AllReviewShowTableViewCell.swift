
import UIKit
import Cosmos

class AllReviewShowTableViewCell: UITableViewCell {
     var vcObj : AllReviewShowTableViewCell?
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabelFontSize!
    @IBOutlet weak var reviewDateLbl: UILabelFontSize!
    @IBOutlet weak var reviewDescriptionLbl: UILabelFontSize!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var likeBtn: UIButtonFontSize!
    @IBOutlet weak var commentBtn: UIButtonCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInterfaceText()
        // Initialization code
    }
    
    func  setUpInterfaceText(){
        ratingView.settings.fillMode = .full

        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.size.height/2.0
        profileImageBtn.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
