//
//  BooksTableViewCell.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

protocol BooksTableViewCellDisplayLogic: class
{
    func displayFavUnfavResponse(viewModel: Home.Favourite, atIndex: Int8)
}

class BooksTableViewCell: UITableViewCell, BooksTableViewCellDisplayLogic {
    
    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabelFontSize!
    @IBOutlet weak var btnViewAll: UIButtonFontSize!
    
    var vcObj : HomeViewController?
    var worker: HomeWorker?
    var isRecently : Bool!
    var arrRecent : [Home.ViewModel.RecentBooks]?
    var arrPopular : [Home.ViewModel.PopularBooks]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        booksCollectionView.register(UINib(nibName: ViewControllerIds.BooksCollectionCell, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.BooksCollectionCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    //MARK:- Interface Builder Action --

    @IBAction func actionViewAll(_ sender: UIButton) {
        
        if isRecently == true {
            
            if arrRecent!.count > 0 {
                vcObj?.router?.navigateToAllBooks(withTitle: localizedTextFor(key: HomeSceneText.RecentlyAddedTitle.rawValue),
                                                  andCatId: nil,
                                                  orderNo: "1")
            }
           
        } else {
            if arrPopular!.count > 0 {
                vcObj?.router?.navigateToAllBooks(withTitle: localizedTextFor(key: HomeSceneText.MostPopularTitle.rawValue), andCatId: nil, orderNo: "2")
            }
        }
    }
    
    
    //MARK:- Class Helper --

    func setPoppular(cell: BooksCollectionViewCell!, withData: Home.ViewModel.PopularBooks, atIndexPath: IndexPath)  {
        
        let strReview = " \((withData.review_count)!) \((localizedTextFor(key: GeneralText.ReviewsTitle.rawValue))) "
        
        cell.imgBookCover.backgroundColor = UIColor.clear
        cell.imgBookCover.sd_setImage(with: URL(string:(withData.cover_photo!)), placeholderImage: UIImage(named: "defaultBookImage"))
        cell.lblBookName.text = withData.name
        cell.lblAuthorName.text = withData.author_name
        cell.btnReviews.setTitle(strReview, for: .normal)
        cell.ratingView.settings.totalStars = 1
        cell.ratingView.rating = withData.rating!
        cell.ratingView.text = "\(Float(withData.rating!))"

        cell.btnReviews.tag = atIndexPath.item
        cell.btnReviews.addTarget(self, action: #selector(actionAllReviews(_:)), for: .touchUpInside)
        cell.btnFavUnfav.tag = atIndexPath.item
        cell.btnFavUnfav.addTarget(self, action: #selector(actionFavouriteUnfavorite(_:)), for: .touchUpInside)
        cell.btnBookSelf.tag = atIndexPath.item
        cell.btnBookSelf.addTarget(self, action: #selector(actionAddToShelves(_:)), for: .touchUpInside)
        
        if withData.shelves!.count > 0 {
            if withData.shelves![0].is_favourite == true {
                cell.btnFavUnfav.tintColor = appThemeColor
            } else {
                cell.btnFavUnfav.tintColor = UIColor.gray
            }
            cell.btnBookSelf.tintColor = appThemeColor
        } else {
            cell.btnFavUnfav.tintColor = UIColor.gray
            cell.btnBookSelf.tintColor = UIColor.gray
        }
        
    }
    
    
    func setRecent(cell: BooksCollectionViewCell!, withData: Home.ViewModel.RecentBooks, atIndexPath: IndexPath) {
        
        let strReview = " \((withData.review_count)!) \((localizedTextFor(key: GeneralText.ReviewsTitle.rawValue))) "
        
        cell.imgBookCover.backgroundColor = UIColor.clear
        cell.imgBookCover.sd_setImage(with: URL(string:(withData.cover_photo!)), placeholderImage: UIImage(named: "defaultBookImage"))
        cell.lblBookName.text = withData.name
        cell.lblAuthorName.text = withData.author_name
        cell.btnReviews.setTitle(strReview, for: .normal)
        cell.ratingView.settings.totalStars = 1
        cell.ratingView.rating = withData.rating!
        cell.ratingView.text = "\(Float(withData.rating!))"
        
        cell.btnReviews.tag = atIndexPath.item
        cell.btnFavUnfav.tag = atIndexPath.item
        cell.btnBookSelf.tag = atIndexPath.item
        
        cell.btnReviews.addTarget(self, action: #selector(actionAllReviews(_:)), for: .touchUpInside)
        cell.btnFavUnfav.addTarget(self, action: #selector(actionFavouriteUnfavorite(_:)), for: .touchUpInside)
        cell.btnBookSelf.addTarget(self, action: #selector(actionAddToShelves(_:)), for: .touchUpInside)
       
        if withData.shelves!.count > 0 {
            
            if withData.shelves![0].is_favourite == true {
                cell.btnFavUnfav.tintColor = appThemeColor
            } else {
                cell.btnFavUnfav.tintColor = UIColor.gray
            }
            cell.btnBookSelf.tintColor = appThemeColor
            
        } else {
            cell.btnFavUnfav.tintColor = UIColor.gray
            cell.btnBookSelf.tintColor = UIColor.gray
        }
    }
    
    
    func loadEmptyDataAt(cell: BooksCollectionViewCell!, atIndexPath: IndexPath) {
        cell.imgBookCover.backgroundColor = appThemeColor
        
        cell.btnReviews.tag = atIndexPath.item
        cell.btnFavUnfav.tag = atIndexPath.item
        cell.btnBookSelf.tag = atIndexPath.item
        
        cell.btnReviews.addTarget(self, action: #selector(actionAllReviews(_:)), for: .touchUpInside)
        cell.btnFavUnfav.addTarget(self, action: #selector(actionFavouriteUnfavorite(_:)), for: .touchUpInside)
        cell.btnBookSelf.addTarget(self, action: #selector(actionAddToShelves(_:)), for: .touchUpInside)
    }
    
    
    func presentFavUnfavResponse(response: ApiResponse) {
        
        if response.error != nil {
            // Alert
        } else {
            // render data
        }
    }
    
    
    func presentAddToShelfError() {
        CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: HomeValidationText.AddToShelf.rawValue))
    }
    
    
    func displayFavUnfavResponse(viewModel: Home.Favourite, atIndex: Int8) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
        }
    }
    
    //MARK:- Cell Interface Builder Action --
    
    @objc func actionFavouriteUnfavorite(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            var param: [String : Any]?

            if isRecently == true {
                
                if (arrRecent![sender.tag].shelves?.count)! > 0 {
                    let likeStatus = ((arrRecent![sender.tag].shelves)![0].is_favourite)! == true ? false : true
                    param = [
                        "id":"\(((arrRecent![sender.tag].shelves)![0].id)!)",
                        "user_id":CommonFunctions.sharedInstance.getUserId(),
                        "is_favourite":likeStatus]
                } else {
                    presentAddToShelfError()
                    return
                }

            } else {
                
                if (arrPopular![sender.tag].shelves?.count)! > 0 {
                  let likeStatus = ((arrPopular![sender.tag].shelves)![0].is_favourite)! == true ? false : true
                   param = [
                    "id":"\(((arrPopular![sender.tag].shelves)![0].id)!)",
                    "user_id":CommonFunctions.sharedInstance.getUserId(),
                    "is_favourite":likeStatus]
                } else {
                    presentAddToShelfError()
                    return
                }
            }
            
            CommonFunctions.sharedInstance.hitFavouriteUnfavouriteApi(withData: param!) { (response) in
                
                if response.code == SuccessCode {
                    
                    let result = response.result as! NSDictionary
                    
                    CustomAlertController.sharedInstance.showSuccessAlert(success: (result["result"] as? String)!)
                    
                    if self.isRecently == true {
                        var recentData = self.arrRecent![sender.tag]
                        var shelfData = recentData.shelves![0]
                        shelfData.is_favourite = shelfData.is_favourite == true ? false : true
                        recentData.shelves![0] = shelfData
                        self.arrRecent![sender.tag] = recentData
                    } else {
                        var popData = self.arrPopular![sender.tag]
                        var shelfData = popData.shelves![0]
                        shelfData.is_favourite = shelfData.is_favourite == true ? false : true
                        popData.shelves![0] = shelfData
                        self.arrPopular![sender.tag] = popData
                    }
                    self.booksCollectionView.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
                    
                } else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            }
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @objc func actionAllReviews(_ sender: UIButton) {
         //.CustomAlertController.sharedInstance.showComingSoonAlert()
        
        if isRecently == true {
            if arrRecent!.count > 0 {
                vcObj?.router?.navigateToAllReview(bookId: "\((arrRecent![sender.tag].id)!)")
            }
        } else {
            if arrPopular!.count > 0 {
                vcObj?.router?.navigateToAllReview(bookId: "\((arrPopular![sender.tag].id)!)")
            }
        }
    }
    
    @objc func actionAddToShelves(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            var status: Int?
            var isLike: Bool?
            var bookId: Int?
            var bookName: String?
            var bookImg: String?
            
            if isRecently == true {
                
                bookId = arrRecent![sender.tag].id
                bookName = arrRecent![sender.tag].name
                bookImg = arrRecent![sender.tag].cover_photo
                if (arrRecent![sender.tag].shelves?.count)! > 0 {
                    status = (arrRecent![sender.tag].shelves)![0].shelf_status
                    isLike = (arrRecent![sender.tag].shelves)![0].is_favourite
                } else {
                    status = 3
                    isLike = false
                }
            } else {
                
                bookId = arrPopular![sender.tag].id
                bookName = arrPopular![sender.tag].name
                bookImg = arrPopular![sender.tag].cover_photo

                if (arrPopular![sender.tag].shelves?.count)! > 0 {
                    status = (arrPopular![sender.tag].shelves)![0].shelf_status
                    isLike = (arrPopular![sender.tag].shelves)![0].is_favourite
                } else {
                    status = 3
                    isLike = false
                }
            }
            let data:[String:Any] = ["book_id":bookId!,"shelf_status":status!,"is_favourite":isLike!, "isFrom":"Home", "cover_photo":bookImg!, "name":bookName!]
            vcObj?.router?.navigateToBookShelves(withData: data)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
}


extension BooksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width-30)/2.30, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isRecently == true {
            return arrRecent!.count > 0 ? arrRecent!.count : 3
        } else {
            return arrPopular!.count > 0 ? arrPopular!.count : 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.BooksCollectionCell, for: indexPath) as! BooksCollectionViewCell
        
        if isRecently == true {
            
            if arrRecent!.count > 0 {
                setRecent(cell: cell, withData: arrRecent![indexPath.item], atIndexPath: indexPath)
            } else {
                loadEmptyDataAt(cell: cell, atIndexPath: indexPath)
            }
            
        } else {
            
            if arrPopular!.count > 0 {
                setPoppular(cell: cell, withData: arrPopular![indexPath.item], atIndexPath: indexPath)
            } else {
                loadEmptyDataAt(cell: cell, atIndexPath: indexPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isRecently == true {
            if arrRecent!.count > 0 {
                vcObj?.router?.navigateToBookDetail(bookId: "\((arrRecent![indexPath.item].id)!)")
            }
        } else {
            if arrPopular!.count > 0 {
                vcObj?.router?.navigateToBookDetail(bookId: "\((arrPopular![indexPath.item].id)!)")
            }
        }
    }
    
    
}

