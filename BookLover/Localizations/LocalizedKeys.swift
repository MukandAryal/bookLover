//
//  LocalizedKeys.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import Foundation



enum SceneTitleText: String {
    
    case loginSceneTitle = "loginSceneTitle"
    case HomeSceneTitle = "HomeSceneTitle"
    case NotificationsSceneTitle = "NotificationsSceneTitle"
    case ChatSceneTitle = "ChatSceneTitle"
    case MyBooksSceneTitle = "MyBooksSceneTitle"
    case FriendsSceneTitle = "FriendsSceneTitle"
    case SettingsSceneTitle = "SettingsSceneTitle"
    case MyProfileSceneTitle = "MyProfileSceneTitle"
    case ReaderProfileSceneTitle = "ReaderProfileSceneTitle"
    case MyFriendTitle      = "MyFriendTitle"
    case AddFriendTitle     = "AddFriendTitle"
    case SearchMyFriendTitle = "SearchMyFriendTitle"
    case WantToReadTitle     = "WantToReadTitle"
    case ProfileSceneTitle = "ProfileSceneTitle"
    case NotificationTabTitle = "NotificationTabTitle"
    case FriendRequestTabTitle = "FriendRequestTabTitle"

    case CompleteProfileSceneTitle = "CompleteProfileSceneTitle"
    
    case AddFriendSceneTitle = "AddFriendSceneTitle"
    case EmailVerificationSceneTitle = "EmailVerificationSceneTitle"
    
    case ShareBooksSceneTitle = "ShareBooksSceneTitle"
    case ReviewSceneTitle = "ReviewSceneTitle"
    case ForgotPasswordSceneTitle = "ForgotPasswordSceneTitle"
    case CountrySceneTitle = "CountrySceneTitle"
    case StateSceneTitle = "StateSceneTitle"
    case ReviewDetailSceneTitle = "ReviewDetailSceneTitle"
    case FriendProfileTitle = "FriendProfileTitle"
    case AgeSelectTitle = "AgeSelectTitle"
    case DetailSceneTitle = "DetailSceneTitle"
}

enum HomeSceneText: String {
    case Category = "Category"
    case RecentlyAddedTitle = "RecentlyAddedTitle"
    case MostPopularTitle = "MostPopularTitle"
    case ViewAllTitle = "ViewAllTitle"
    case NumberOfBooksTitle = "NumberOfBooksTitle"
}

enum ShelvesSceneText:String {
    case ShelvesSceneTitle = "ShelvesSceneTitle"
    case ShelvesSceneReadButton = "ShelvesSceneReadButton"
    case ShelvesSceneWantToReadButton = "ShelvesSceneWantToReadButton"
    case ShelvesSceneContinueReadingButton = "ShelvesSceneContinueReadingButton"
    case ShelvesSceneCollectionXibName = "ShelvesSceneCollectionXibName"
}

enum WithOutLoginValidation: String {
    case WriteReviewText = "WriteReviewText"
    case AddToShelfText = "AddToShelfText"
    case RateBookText = "RateBookText"
    case LikeReviewText = "LikeReviewText"
    case CommentText = "CommentText"
    case ShareBookText = "ShareBookText"
}

enum OnBoardingModuleText: String {
    
    case UserNameTextFieldPlaceholder = "UserNameTextFieldPlaceholder"
    case PasswordTextFieldPlaceholder = "PasswordTextFieldPlaceholder"
    case ForgotPasswordButtonTitle = "ForgotPasswordButtonTitle"
    case LoginButtonTitle = "LoginButtonTitle"
    case LoginWithFBButtonTitle = "LoginWithFBButtonTitle"
    case RegisterButtonTitle = "RegisterButtonTitle"
    case NewHereTitle = "NewHereTitle"
    case OrTitle = "OrTitle"
    case EmailAddressPlaceholder = "EmailAddressPlaceholder"
    case SubmitButtonTitle = "SubmitButtonTitle"
    case NameTextFieldPlaceholder = "NameTextFieldPlaceholder"
    case LastNamePlaceholder = "LastNamePlaceholder"
    case ConfirmPasswordPlaceholder = "ConfirmPasswordPlaceholder"
    case AlreadyHaveAccountTitle = "AlreadyHaveAccountTitle"
    case AgePlaceholder = "AgePlaceholder"
    case GenderPlaceholder = "GenderPlaceholder"
    case CountryPlaceholder = "CountryPlaceholder"
    case StatePlaceholder = "StatePlaceholder"
    case AboutPlaceholder = "AboutPlaceholder"
    case EditPhotoTitle = "EditPhotoTitle"
    case SaveChangesButtonTitle = "SaveChangesButtonTitle"
    case SkipButton = "SkipButton"
    case SelectCountryTitle = "SelectCountryTitle"
    case SelectStateTitle = "SelectStateTitle"
    case SelectGenderTitle = "SelectGenderTitle"
}


enum SettingsModuleText:String {
    
    case AccountSettingsTitle = "AccountSettingsTitle"
    case ChangeEmailTitle = "ChangeEmailTitle"
    case ResetPasswordTitle = "ResetPasswordTitle"
    case DeleteAccountTitle = "DeleteAccountTitle"
    case WantToDeleteTitle = "WantToDeleteTitle"
    case ConfirmDeleteTitle = "ConfirmDeleteTitle"
    case EmailVarificationTitle = "EmailVarificationTitle"
    case Enter4DigitCodeTitle = "Enter4DigitCodeTitle"
    case DidNotGetCodeTitle = "DidNotGetCodeTitle"
    case ResendCodeTitle = "ResendCodeTitle"
    case OldPasswordTitle = "OldPasswordTitle"
    case NewPasswordTitle = "NewPasswordTitle"
    case ConfirmNewPasswordTitle = "ConfirmNewPasswordTitle"
    case ProfileSettingsTitle = "ProfileSettingsTitle"
    case PrivacySettingsTitle = "PrivacySettingsTitle"
    case ReviewsSettingTitile = "ReviewsSettingTitile"
    case OtherPrivacyTitle    = "OtherPrivacyTitle"
    case LogoutTitle = "LogoutTitle"
}


// Privacy Setting

enum PrivacySettingText: String {
    case profilePrivacy = "profilePrivacy"
    case reviewsPrivacy = "reviewsPrivacy"
    case other          = "other"
    case BlockTitle = "BlockTitle"
    case ReportTitle = "ReportTitle"
}

// Profile Setting

enum ProfilePrivacyText: String {
    case profilePicture = "profilePicture"
    case addressEmail   = "addressEmail"
    case age            = "age"
    case gender         = "gender"
    case publicTitle         = "publicTitle"
    case friendTitle         = "friendTitle"
    case noOneTitle          = "noOneTitle"
    case ReportToAdminMessage = "ReportToAdminMessage"
    case SaveSettingTitle = "SaveSettingTitle"
}

// Reviews Privacy

enum ReviewsPrivacyText: String {
    case whoCanfollowMe = "whoCanfollowMe"
    case whoCanComment   = "whoCanComment"
}

// Other Privacy

enum OtherPrivacyText: String {
    case acceptPrivateMessage = "acceptPrivateMessage"
    case lastSeen = "lastSeen"
}

// Reset Password

enum ResetPasswordText: String {
    case oldPassword = "oldPassword"
    case newPassword = "newPassword"
    case confirmNewPassword = "confirmNewPassword"
    case confromPassword = "case oldPassword"
    case confirmPassword = "confirmPassword"
}

// Account Setting

enum AccountSettingText: String {
    case emailAddress = "emailAddress"
    case password      = "password"
    case deleteAccount = "deleteAccount"
    case changeEmail   = "changeEmail"
    case changePassword = "changePassword"
}

// Email Verfication

enum EmailVerficationText: String {
    case enter4digitcode = "enter4digitcode"
    case submit          = "submit"
    case dontGetTheCode  = "dontGetTheCode"
    case resendCode      = "resendCode"
}


// Notification/Friend Request

enum NotificationFriendRequestText: String {
    case notification = "notification"
    case friendRequest = "friendRequest"
    case accept         = "accept"
    case decline        = "decline"
}

// Add Friend Readers/FbReaders

enum AddFriendRequestReadersText: String {
    case readers = "readers"
    case fbreaders = "fbreaders"
    case plusadd   = "plusadd"
    case Filter    = "Filter"
    case similarInterest = "similarInterest"
    case Cancel = "Cancel"
}

enum BookPopUpText: String {
    
    case BookShelvesTitle = "BookShelvesTitle"
    case Read = "Read"
    case WantToRead   = "WantToRead"
    case Reading   = "Reading"
}

enum BookDetailText: String {
    
    case AuthorTitle = "AuthorTitle"
    case PublisherTitle = "PublisherTitle"
    case IsbnTitle = "IsbnTitle"
    case TotalPageTitle = "TotalPageTitle"
    case ShareTitle = "ShareTitle"
    case BookShelfTitle =  "BookShelfTitle"
    case RateTheBookTitle =  "RateTheBookTitle"
    case BookDescTitle =  "BookDescTitle"
    case WriteReviewTitle =  "WriteReviewTitle"
    case AllReviewTitle =  "AllReviewTitle"
}

//MARK:- UserReview
enum UserReviewText: String {
    case AddYourComment = "AddYourComment"
    case Comments = "Comments"
}

//MARK:- AddCommentText
enum AddCommentText: String {
    case AddYourComment = "AddYourComment"
    case WriteYourCommentHere = "WriteYourCommentHere"
    case AddCommentSubmit = "AddCommentSubmit"
    case WriteMessage = "WriteMessage"
}

//MARK:- RateAndReviewText
enum RateAndReviewText: String {
    case RateAndReviewThisBook = "RateAndReviewThisBook"
    case RateAndReviewSubmit = "RateAndReviewSubmit"
    case WriteYourReview = "WriteYourReview"
}

//MARK:- UserProfileText
enum UserProfileText: String {
    case AgeGender = "AgeGender"
    case Location  = "Location"
    case Joined    = "Joined"
    case LastActive = "LastActive"
    case Chat       = "Chat"
    case SendRequest = "SendRequest"
    case CancelRequest = "CancelRequest"
    case FavouriteBooks = "FavouriteBooks"
    case MyFriends      = "MyFriends"
    case BookShelves    = "BookShelves"
    case Read           = "Read"
    case WantToRead     = "WantToRead"
    case CurrentlyReading = "CurrentlyReading"
    case About             = "About"
    case UnfriendTitle = "UnfriendTitle"
    case TypingTitle = "TypingTitle"
}

enum RatingvalidationText: String {
    case writeRating = "writeRating"
    case writeDescription = "writeDescription"
    case writeComment = "writeComment"
}

//MARK:- FilterAgeText
enum FilterAgeText: String {
    case byFiler = "byFiler"
    case ByAge   = "ByAge"
    case Reset   = "Reset"
    case ByGender = "ByGender"
    case ByLocation = "ByLocation"
    case Male       = "Male"
    case Female      = "Female"
    case TypeLocation = "TypeLocation"
    case NearMe      = "NearMe"
    case Apply        = "Apply"
    case Country      = "Country"
    case State        = "State"
}

//MARK:- SearchMyFriendText
enum SearchMyFriendText: String {
    case SearchmyFreind = "SearchmyFreind"
    case RecentSearch   = "RecentSearch"
    case PlusAdd        = "PlusAdd"
    case Search = "Search"
}


enum GeneralText:String {
    case SaveTitle = "SaveTitle"
    case imageUploadedSuccess = "imageUploadedSuccess"
    case keyboardDoneButton = "keyboardDoneButton"
    case appName = "okursever"
    case no = "no"
    case yes = "yes"
    case cancel = "cancel"
    case editRow = "editRow"
    case deleteRow = "deleteRow"
    case pleaseLogin = "pleaseLogin"
    case gpsPermission = "gpsPermission"
    case cameraPermission = "cameraPermission"
    case noSalonAvailableMessage = "noSalonAvailableMessage"
    case noAppointmentsAvailableMessage = "noAppointmentsAvailableMessage"
    case permissionHeading = "permissionHeading"
    case nextButton = "nextButton"
    case bhd = "bhd"
    case ok = "ok"
    case doneButton = "doneButton"
    case comingSoon = "comingSoon"
    case ReviewsTitle = "ReviewsTitle"
    case SearchTitle = "SearchTitle"
}

// Validations

enum HomeValidationText: String {
    case AddToShelf = "AddToShelf"
}

enum CompleteProfileValidationText: String {
    case MaxAgeLimit = "MaxAgeLimit"
    case SelectCountryFirst = "SelectCountryFirst"
}



enum ValidationsText:String {
    
    case emptyName = "emptyName"
    case emptyPhoneNumber = "emptyPhoneNumber"
    case phoneNumberMinLength = "phoneNumberMinLength"
    case invalidPhoneNumber = "invalidPhoneNumber"
    case emptyPassword = "emptyPassword"
    case emptyNewPassword = "emptyNewPassword"
    case emptyConfirmPassword = "emptyConfirmPassword"
    case confirmPasswordMatch = "confirmPasswordMatch"
    case passwordLength = "passwordLength"
    case emptyEmail = "emptyEmail"
    case invalidEmail = "invalidEmail"
    case emptyArea = "emptyArea"
    case emptyBirthdate = "emptyBirthdate"
    case emptyCountryCode = "emptyCountryCode"
    
    case kNetworkError = "kNetworkError"
    case kJsonError = "kJsonError"
    case kServerError = "kServerError"
}


// Custom Image Picker Wrapper

enum CustomImagePickerText:String {
    case openCamera = "openCamera"
    case openGallery = "openGallery"
}

enum BookPopUpValidation: String {
    case AddStatus = "AddStatus"
}

enum EmailVerificationValidationText: String {
    case otpTitle = "otpTitle"
}

//MARK:- General Validations

enum GeneralValidations: String {
    
    case ProgressLoadingKey = "ProgressLoadingKey"
    case FillAllFieldsKey = "FillAllFieldsKey"
    case EnterEmailKey = "EnterEmailKey"
    case InvalidEmailKey = "InvalidEmailKey"
    case EnterPasswordKey = "EnterPasswordKey"
    case PasswordValidaton = "PasswordValidaton"
    case OldPasswordKey = "OldPasswordKey"
    case ConfirmPasswordKey = "ConfirmPasswordKey"
    case EnterFirstNameKey = "EnterFirstNameKey"
    case EnterLastNameKey = "EnterLastNameKey"
    case EnterPhoneNumberKey = "EnterPhoneNumberKey"
    case InvalidPhoneNumberKey = "InvalidPhoneNumberKey"
    case PasswordLengthKey = "PasswordLengthKey"
    case ConfirmYourPasswordKey = "ConfirmYourPasswordKey"
    case MismatchPasswordKey = "MismatchPasswordKey"
    case SamePasswordKey = "SamePasswordKey"
    case MismatchEmailKey = "MismatchEmailKey"
    case ProfileUpadtedKey = "ProfileUpadtedKey"
    case NoInternetConnectionKey = "NoInternetConnectionKey"
    case TryAgainKey = "TryAgainKey"
    case EmailAlreadyExistKey = "EmailAlreadyExistKey"
    case LoginFirstKey = "LoginFirstKey"
}


enum NoDataFoundScene: String {
    case NoDataFouund = "NoDataFouund"
    case NoCommentFound =  "NoCommentFound"
    case NoNotificationFound = "NoNotificationFound"
    case NoReviewFound       = "NoReviewFound"
    case NoBookFound = "NoBookFound"
    case NoFriendFound = "NoFriendFound"
    case NoFriendMatch = "NoFriendMatch"
}

enum SucessfullyMessage: String {
    case AccountDeleteSucessfully = "AccountDeleteSucessfully"
    case FriendrequestcancelledSucessfully   = "FriendrequestcancelledSucessfully"
    case FriendRequestAccepted   = "FriendRequestAccepted"
    case PrivacyPolicyMessage =  "PrivacyPolicyMessage"
    case Revieweditedsucessfully = "Revieweditedsucessfully"
    case Addratingsucessfully  = "Addratingsucessfully"
    case Addcommentssucessfully = "Addcommentssucessfully"
}

enum ErrorMessage : String {
    case Blockedbyreader = "Blockedbyreader"
}


enum TimeStrings : String {
    
    case YearsAgo = "YearsAgo"
    case OneYearAgo = "OneYearAgo"
    case LastYear = "LastYear"
    
    case MonthsAgo = "MonthsAgo"
    case OneMonthsAgo = "OneMonthsAgo"
    case LastMonth = "LastMonth"

    case WeeksAgo = "WeeksAgo"
    case OneWeekAgo = "OneWeekAgo"
    case LastWeek = "LastWeek"
    
    case DaysAgo = "DaysAgo"
    case OneDayAgo = "OneDayAgo"
    case Yesterday = "Yesterday"
    
    case HoursAgo = "HoursAgo"
    case OneHourAgo = "OneHourAgo"
    case AnHourAgo = "AnHourAgo"
    
    case MinutesAgo = "MinutesAgo"
    case OneMinuteAgo = "OneMinuteAgo"
    case A_MinuteAgo = "A_MinuteAgo"
    
    case SecondsAgo = "SecondsAgo"
    case JustNow = "JustNow"
    
}
