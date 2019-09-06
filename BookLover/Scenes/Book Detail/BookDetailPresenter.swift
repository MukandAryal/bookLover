//
//  BookDetailPresenter.swift
//  BookLover
//
//  Created by ios 7 on 28/05/18.
//  Copyright (c) 2018 iOS Team. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BookDetailPresentationLogic
{
  func presentBookDetail(response: ApiResponse)
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int)
    func presentFavUnfavoriteResponse(reponse: ApiResponse)

}

class BookDetailPresenter: BookDetailPresentationLogic
{
    weak var viewController: BookDetailDisplayLogic?
    
    
    // MARK: Do something

    func presentBookDetail(response: ApiResponse) {
        
        var model = BookDetail.ViewModel()
        
        if response.code == SuccessCode {
            
            let result = response.result as! NSDictionary
            let reviewList = getReviewList(result: result)
            let books = getBookData(result: (result["books"] as? [String:Any])!)
            
            var userReview : BookDetail.ViewModel.User_Review? = nil
            
            if result["user_review"] != nil, let _ = result["user_review"] as? [String:Any] {
                
                let userRev = (result["user_review"] as? [String:Any])!
                userReview = BookDetail.ViewModel.User_Review(
                    id: userRev["id"] as? Int,
                    user_id: userRev["user_id"] as? Int,
                    book_id: userRev["book_id"] as? Int,
                    description: userRev["description"] as? String,
                    rating: userRev["rating"] as? Double,
                    status: userRev["status"] as? Int,
                    is_deleted: userRev["is_deleted"] as? Bool,
                    created_at: userRev["created_at"] as? String,
                    updated_at: userRev["updated_at"] as? String,
                    likeCount: userRev["likeCount"] as? Int,
                    commentCount: userRev["commentCount"] as? Int,
                    is_like: userRev["is_like"] as? Bool)
            }
            
            model = BookDetail.ViewModel(books: books, reviewList: reviewList, userReview: userReview, error: nil)
        }else{
            model = BookDetail.ViewModel(books: nil, reviewList: nil, userReview: nil, error: response.error)
        }
        viewController?.displayBookDetail(viewModel: model)
    }
    
    
    
    func getBookData(result: [String:Any]) -> BookDetail.ViewModel.Books {
        
        var shelfList = [BookDetail.ViewModel.Books.Shelves]()
        if result["shelves"] != nil {
            
            for shelfObj in (result["shelves"] as? [[String:Any]])! {
                
                let shelf = BookDetail.ViewModel.Books.Shelves(
                    id: shelfObj["id"] as? Int,
                    user_id: shelfObj["user_id"] as? Int,
                    book_id: shelfObj["book_id"] as? Int,
                    shelf_status: shelfObj["shelf_status"] as? Int,
                    is_favourite: shelfObj["is_favourite"] as? Bool)
                
                shelfList.append(shelf)
            }
        }
        
        let catObj = result["category"] as? [String:Any]
        let catData = BookDetail.ViewModel.Books.Category(
            id: catObj!["id"] as? Int,
            name: catObj!["name"] as? String,
            description: catObj!["description"] as? String,
            category_image: catObj!["category_image"] as? String,
            status: catObj!["status"] as? Int,
            is_deleted: catObj!["is_deleted"] as? Bool)
        
        return BookDetail.ViewModel.Books(
            id: result["id"] as? Int,
            name: result["name"] as? String,
            isbn_no: result["isbn_no"] as? String,
            category_id: result["category_id"] as? Int,
            author_name: result["author_name"] as? String,
            pages: result["pages"] as? Int,
            description: result["description"] as? String,
            cover_photo: result["cover_photo"] as? String,
            publisher_name: result["publisher_name"] as? String,
            country: result["country"] as? String,
            is_deleted: result["is_deleted"] as? Bool,
            created: result["created"] as? String,
            rating: result["rating"] as? Double,
            review_count: result["review_count"] as? Int,
            shelves: shelfList,
            category: catData)
    }
    
    func getReviewList(result: NSDictionary) ->  [BookDetail.ViewModel.Review] {
        
        var list = [BookDetail.ViewModel.Review]()
        for obj in (result["reviews"] as? [[String:Any]])! {
            
            let userObj = (obj["user"] as? [String:Any])!
            
            let userInfo = CommonFunctions.sharedInstance.getReaderInfo(userinfo: userObj)
            
            let review = BookDetail.ViewModel.Review(
                is_Like: obj["is_like"] as? Bool,
                book_id: obj["book_id"] as? Int16,
                commentCount: obj["commentCount"] as? Int,
                created_at: obj["created_at"] as? String,
                description: obj["description"] as? String,
                id: obj["id"] as? Int16,
                is_deleted: obj["is_deleted"] as? Bool,
                likeCount: obj["likeCount"] as? Int,
                rating: obj["rating"] as? Double,
                status:  obj["status"] as? Bool,
                updated_at: obj["updated_at"] as? String,
                user: userInfo)
            
            list.append(review)
        }
        return list
    }
    
    
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int) {
        
        var model = ShowAllReview.LikeUnlikeModel()
        if response.code == SuccessCode {
            model = ShowAllReview.LikeUnlikeModel(error: nil, success: "")
        } else {
            model = ShowAllReview.LikeUnlikeModel(error: response.error, success: nil)
        }
        viewController?.displayLikeUnlikeReview(viewModel: model, atIndex: atIndex)
    }
    
    
    func presentFavUnfavoriteResponse(reponse: ApiResponse) {
        
        var model = BookDetail.ViewModel.FavUnfavorite()
        if reponse.code == SuccessCode {
            let result = reponse.result as! NSDictionary
            model = BookDetail.ViewModel.FavUnfavorite(success: (result["result"] as? String)!, error: nil)
        } else {
            model = BookDetail.ViewModel.FavUnfavorite(success: nil, error: reponse.error)
        }
        viewController?.displayFavUnfavourite(viewModel: model)
    }
}
