
import UIKit

class SearchMyFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var lblUserName: UILabelFontSize!
    @IBOutlet weak var lblAgeGender: UILabelFontSize!
    @IBOutlet weak var lblLocation: UILabelFontSize!
    @IBOutlet weak var categaryColletionVew: UICollectionView!
    @IBOutlet weak var progressLabel: UILabelFontSize!
    @IBOutlet weak var progressBarView: UIProgressView!
    var arrCategory : [String]?
    var vcObj : SearchMyFriendsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.frame.size.height/2.0
        btnProfilePic.clipsToBounds = true
        categaryColletionVew.register(UINib(nibName: ViewControllerIds.CategaryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.CategaryCellIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension SearchMyFriendsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var strText : String!
        strText = "\((arrCategory![indexPath.item]))"
        
        let dynamicWidth =  strText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont(name: FontName, size: 12)!], context: nil).size.width
        
        return CGSize(width: dynamicWidth+10, height: 30)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory!.count
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
