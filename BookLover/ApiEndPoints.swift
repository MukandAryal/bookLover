//
//  ApiEndPoints.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class ApiEndPoints: NSObject {
    
    static let login = "users/login.json"
    static let register = "users/add.json"
    static let country = "users/getCountries.json"
    static let state = "users/getState/"
    static let userInfo = "users/getProfile.json"
    static let updateProfile = "users/edit.json"
    static let forgotPassword = "users/forgotpassword.json"
    static let getDashBoard = "users/getDashboard.json"
    static let getAllBooks  = "books/index.json"
    static let allReviews    = "reviews/index.json"
    static let likeDislike = "books/setLike.json"
    static let shelfStatus = "shelves/updateStatus.json"
    static let userReview   = "reviews/view.json"
    static let bookDetail = "books/view/"
    
    static let addComment   = "comments/add.json"
    static let writeRating  = "reviews/addReview.json"
    static let friendsList  = "friends/index/"
    static let shareTheBook = "sharedBooks/shareBooks.json"
    static let GetUserProfile  = "users/getProfile/"
    static let reviewLikeDislike = "reviewLikes/likeReview.json"
    static let editWriteRating = "reviews/edit.json"
    static let deleteReview = "reviews/delete1/"
    
    static let blockUser = "friends/block.json"
    static let reportUser = "reportedUsers/add.json"
    static let getBookShelvesStatus = "shelves/index.json"
    
    static let ResetPasword    = "users/resetPassword.json"
    static let SendOtp         = "users/sendOtp.json"
    static let VerifyOtp       = "users/verifyOtp.json"
    static let AccountDelete   = "users/delete/"
    static let ChangeEmail     = "users/updateEmail.json"
    static let PrivicySet      = "privacies/edit.json"
    static let SendFriendRequest = "friends/add.json"
    static let CancelFriendRequest = "friends/edit.json"
    static let GetFriends      = "users/index.json"
    static let AddFriend      = "friends/add.json"
    static let GetNotification = "notifications/index.json"
    static let GetFriendRequest = "friends/index/"
    static let GetChatList      = "chats/chats.json"
    static let ChatHistory      =  "chats/index.json"
    static let RedirectNotification = "notifications/updateStatus.json"
}
