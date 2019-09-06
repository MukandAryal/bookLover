
import UIKit

class AddFriendFbTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImgBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var userAgeLabel: UILabelFontSize!
    @IBOutlet weak var userLocationLabel: UILabelFontSize!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fbFriendCollectionView: UICollectionView!
    var arrCategory : [String]?
    var vcObj : AddFriendViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImgBtn?.layer.cornerRadius = (userImgBtn?.frame.size.height)!/2.0
        userImgBtn?.clipsToBounds = true
        
        addButton?.layer.cornerRadius = ((addButton?.frame.size.height))!/2.0
        addButton?.clipsToBounds = true
        
        addButton?.setTitle(localizedTextFor(key:AddFriendRequestReadersText.plusadd.rawValue), for:.normal)
        
        fbFriendCollectionView.register(UINib(nibName: ViewControllerIds.CategaryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.CategaryCellIdentifier)
    }
    @IBAction func actionProfilePic(_ sender: Any) {
    }
    @IBAction func actionAddFriendFb(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension AddFriendFbTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var strText : String!
        strText = "\((arrCategory![indexPath.item]))"
        
        let dynamicWidth =  strText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont(name: "Futura", size: 12)!], context: nil).size.width
        
        return CGSize(width: dynamicWidth+10, height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return (arrCategory?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.CategaryCellIdentifier, for: indexPath) as! CategaryCollectionViewCell
        cell.lblCategaryName.text = arrCategory?[indexPath.row]
        cell.lblCategaryName.font = UIFont(
            name: cell.lblCategaryName.font.fontName,
            size: CommonFunctions.sharedInstance.getFontSizeFrom(18.0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
