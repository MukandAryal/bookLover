//
//  CompleteProfileViewController.swift
//  BookLover
//
//  Created by ios 7 on 10/05/18.
//  Copyright (c) 2018 iOS Team. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVFoundation

typealias CountryCompletion = (_ data: [String:Any]?) -> ()
typealias StateCompletion = (_ data: CompleteProfile.ViewModel.StateData?) -> ()

protocol CompleteProfileDisplayLogic: class
{
    func displayStateData(viewModel: CompleteProfile.ViewModel)
    func displayUserData(viewModel: CompleteProfile.UserInfo, isUpdated: Bool)
    func displayUpdateProfile(viewModel: CompleteProfile.UpdateProfile)
}

class CompleteProfileViewController: UIViewController, CompleteProfileDisplayLogic
{
    
    //MARK:- Interface Builder Outlets
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var navigationLabel: UILabelFontSize!
    
    @IBOutlet weak var editProfileLabel: UILabelFontSize!
    @IBOutlet weak var genderLabel: UILabelFontSize!
    @IBOutlet weak var countryLabel: UILabelFontSize!
    @IBOutlet weak var stateLabel: UILabelFontSize!
    @IBOutlet weak var aboutLabel: UILabelFontSize!
    
    @IBOutlet weak var skipButton: UIButtonFontSize!
    @IBOutlet weak var saveButton: UIButtonFontSize!
    @IBOutlet weak var btnGender: UIButtonFontSize!
    @IBOutlet weak var btnCountry: UIButtonFontSize!
    @IBOutlet weak var btnState: UIButtonFontSize!

    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnSelectPic: UIButton!
    @IBOutlet weak var navViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navStackView: UIStackView!

    @IBOutlet var tblGenderHeaderView: UIView!
    @IBOutlet var tblGender: UITableView!
    @IBOutlet weak var btnCancel: UIButtonFontSize!
    @IBOutlet weak var lblGenderTitle: UILabelFontSize!
    
    var interactor: CompleteProfileBusinessLogic?
    var router: (NSObjectProtocol & CompleteProfileRoutingLogic & CompleteProfileDataPassing)?
    var strGender: String?
    var strCountryId: String?
    var isImageTaken: Bool = false
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = CompleteProfileInteractor()
        let presenter = CompleteProfilePresenter()
        let router = CompleteProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        applyFinishingTouchForUiElements()
        getUserData(isUpdated: false)
        if (UserDefaults.standard.object(forKey: userDefualtKeys.countryList.rawValue)) == nil {
            getCountryData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (router?.dataStore?.isSetting)! {
            navViewHeight.constant = 0
            navStackView.isHidden = true
            navigationLabel.isHidden = true
            skipButton.isHidden = true
            CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ProfileSceneTitle.rawValue))
            CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        } else {
            navStackView.isHidden = false
            navViewHeight.constant = 70
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (router?.dataStore?.isSetting)! {
            
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true);
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: Request Methods
    
    func getUserData(isUpdated: Bool) {
        
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        interactor?.getUserInfoData(request: CompleteProfile.Request.UserInfo(user_Id: "\(userId)"), isUpdating: isUpdated)
    }
    
    func getCountryData()
    {
       interactor?.countryListData()
    }
    
    
    func updateProfileData()
    {
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        
        var strState: String = ""
        var strCountry: String = ""
        var strSex: String = ""
        
        if let state = btnState.titleLabel?.text {
            strState = state
        }
        
        if let con = btnCountry.titleLabel?.text {
            strCountry = con
        }
        
        if let gen = btnGender.titleLabel?.text {
            strSex = gen
        }
        
        interactor?.updateProfieData(request: CompleteProfile.Request.UpdateProfile(
            name: tfName.text_Trimmed(),
            lastName: tfLastName.text_Trimmed(),
            about: aboutTextView.text_Trimmed(),
            gender: strSex,
            state: strState,
            country: strCountry,
            user_image: imgUser.image,
            age: tfAge.text_Trimmed(),
            user_Id: "\(userId)"))
    }
    
    // MARK: Response Method
    
    func displayStateData(viewModel: CompleteProfile.ViewModel) {
        if  viewModel.error != nil {
            
        } else {
            router?.navigateToStateScene(withData: viewModel.stateList!)
        }
    }
    
    func displayUserData(viewModel: CompleteProfile.UserInfo, isUpdated: Bool) {
        if  viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            if isUpdated == true {
                CommonFunctions.sharedInstance.navigateToHome(nav: self.navigationController!)
            } else {
                updateUIWithData(data: viewModel)
            }
        }
    }

    func displayUpdateProfile(viewModel: CompleteProfile.UpdateProfile){
        if  viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.result!)
            if (router?.dataStore?.isSetting)! {
                self.navigationController?.popViewController(animated: true)
            } else {
                CommonFunctions.sharedInstance.navigateToHome(nav: self.navigationController!)
            }
        }
    }
    
    // MARK: Interface Builder Action
    
    @IBAction func actionSkip(_ sender: UIButton) {
        self.view.endEditing(true)
        CommonFunctions.sharedInstance.navigateToHome(nav: self.navigationController!)

    }
    
    @IBAction func actionSelectPic(_ sender: UIButton) {
        self.view.endEditing(true)
        let imgPicker = CustomImagePicker()
        imgPicker.delegate = self
        imgPicker.openImagePickerOn(self)
    }
    
    
    @IBAction func actionSelectState(_ sender: UIButton) {
        hideGenderView()
        self.view.endEditing(true)
        if strCountryId != nil {
            interactor?.stateListData(request: CompleteProfile.Request.State(countryId: strCountryId!))
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: CompleteProfileValidationText.SelectCountryFirst.rawValue))
        }
    }
    
    @IBAction func actionSelectCountry(_ sender: UIButton) {
        hideGenderView()
        self.view.endEditing(true)
        router?.navigateToCountryScene()
    }
    
    @IBAction func actionSelectGender(_ sender: UIButton) {
        self.view.endEditing(true)
        showGenderView()
    }
    
    @IBAction func actionCancelGenderPicker(_ sender: UIButton) {
        hideGenderView()
    }
    @IBAction func actionCompleteProfile(_ sender: UIButton) {
        self.view.endEditing(true)
        updateProfileData()
    }
    
    //MARK:- Class Helper --
    
    func hideGenderView() {
        UIView.animate(withDuration: 0.3) {
            self.tblGender.alpha = 0.4
            self.tblGender.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func showGenderView() {
        
        UIView.animate(withDuration: 0.3) {
            self.tblGender.alpha = 1.0
            self.tblGender.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    func presenterCountryDismisedAction() -> CountryCompletion {
        
        return { [unowned self] data in
            if data != nil {
               self.strCountryId = "\((data!["id"] as? Int16)!)"
               self.btnCountry.setTitle((data!["name"] as? String), for: .normal)
               self.btnState.setTitle("", for: .normal)
            }else{
                return
            }
        }
    }
    
    
    func presenterStateDismisedAction() -> StateCompletion {
        
        return { [unowned self] data in
            if data != nil {
                self.btnState.setTitle(data!.name, for: .normal)
            } else {
                return
            }
        }
    }
    
    
    func applyFinishingTouchForUiElements()
    {
        
        tblGender.tableHeaderView = tblGenderHeaderView
        hideGenderView()
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2.0
        imgUser.layer.borderWidth = 2.0
        imgUser.layer.borderColor = UIColor.white.cgColor
        imgUser.clipsToBounds = true
        
        navigationLabel.text = localizedTextFor(key: SceneTitleText.CompleteProfileSceneTitle.rawValue)
        editProfileLabel.text = localizedTextFor(key: OnBoardingModuleText.EditPhotoTitle.rawValue)
        genderLabel.text = localizedTextFor(key: OnBoardingModuleText.GenderPlaceholder.rawValue)
        countryLabel.text = localizedTextFor(key: OnBoardingModuleText.CountryPlaceholder.rawValue)
        stateLabel.text = localizedTextFor(key: OnBoardingModuleText.StatePlaceholder.rawValue)
        aboutLabel.text = localizedTextFor(key: OnBoardingModuleText.AboutPlaceholder.rawValue)
        skipButton.setTitle(localizedTextFor(key: OnBoardingModuleText.SkipButton.rawValue), for: .normal)
        saveButton.setTitle(localizedTextFor(key: OnBoardingModuleText.SaveChangesButtonTitle.rawValue), for: .normal)
        saveButton.layer.cornerRadius = saveButton.frame.size.height/2.0
        
        lblGenderTitle.text = localizedTextFor(key: ProfilePrivacyText.gender.rawValue)
        btnCancel.setTitle(localizedTextFor(key: AddFriendRequestReadersText.Cancel.rawValue), for: .normal)
        
        tfName.placeholder = localizedTextFor(key: OnBoardingModuleText.NameTextFieldPlaceholder.rawValue)
        tfLastName.placeholder = localizedTextFor(key: OnBoardingModuleText.LastNamePlaceholder.rawValue)
        tfAge.placeholder = localizedTextFor(key: OnBoardingModuleText.AgePlaceholder.rawValue)
        
        btnState.setTitle("", for: .normal)
        btnGender.setTitle("", for: .normal)
        btnCountry.setTitle("", for: .normal)
        
    }
    
    func updateUIWithData(data: CompleteProfile.UserInfo) {
        
        strCountryId = getCountryId(str: data.country!)

        tfName.text = data.name
        tfLastName.text = data.lastName
        
        if let age = data.age {
            tfAge.text = "\(age)"
        }
        
        aboutTextView.text = data.about
        btnCountry.setTitle(data.country!, for: .normal)
        btnState.setTitle(data.state! , for: .normal)
        btnGender.setTitle(data.gender!, for: .normal)
        imgUser.sd_setImage(with: URL(string: Configurator.imageBaseUrl + data.user_image!), placeholderImage: UIImage(named: "profile_photo"))
    }
    
    
    
    func getCountryId(str: String) -> String? {
        
        if let object = UserDefaults.standard.object(forKey: userDefualtKeys.countryList.rawValue) {
            let data = NSKeyedUnarchiver.unarchiveObject(with: object as! Data)
            let arrCountryList = data as! [[String:Any]]
            let filterData = arrCountryList.filter { (data) in
                return (data["name"] as! String) == str
            }
            if filterData.count > 0 {
                return "\((filterData[0]["id"] as! Int))"
            }else{
                return nil
            }
        } else {
            return nil
        }
    }
    
}

extension CompleteProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = localizedTextFor(key: FilterAgeText.Male.rawValue)
        } else{
            cell.textLabel?.text = localizedTextFor(key: FilterAgeText.Female.rawValue)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            strGender = localizedTextFor(key: FilterAgeText.Male.rawValue)
        } else {
            strGender = localizedTextFor(key: FilterAgeText.Female.rawValue)
        }
        btnGender.setTitle(strGender, for: .normal)
        hideGenderView()
    }
}

extension CompleteProfileViewController: CustomImagePickerProtocol{
    func didFinishPickingImage(image:UIImage) {
        isImageTaken = true
        imgUser.image = image
    }

    func didCancelPickingImage() {
        isImageTaken = false
    }
}

extension CompleteProfileViewController : UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hideGenderView()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard range.location == 0 else {
            return true
        }
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        hideGenderView()
        return true
    }
}




extension CompleteProfileViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfAge {
            if (string == " ") {
                return false
            }
            return true
        } else if textField == tfName || textField == tfLastName {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NAMETEXT).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }else {
            return true
        }
    }
}

