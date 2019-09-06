//
//  ForgotPasswordViewController.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit

protocol ForgotPasswordDisplayLogic: class
{
    func displayForgotPasswordResponse(viewModel: ForgotPassword.ViewModel)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordDisplayLogic
{
    
    //MARK:- Interface Builder Properties
    
    @IBOutlet weak private var headerImageView: UIImageView!
    
 
    @IBOutlet weak private var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak private var submitButton: UIButtonFontSize!
    
    
    //MARK:- Properties
    
    var interactor: ForgotPasswordBusinessLogic?
    var router: (NSObjectProtocol & ForgotPasswordRoutingLogic & ForgotPasswordDataPassing)?
    
    
    // MARK:- Object Life Cycle
    
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
    
    // MARK:- Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        let router = ForgotPasswordRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK:- View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpUIDesign()
    }
    
    
    //MARK:- Interface Builder Actions
    
    @IBAction func submitButtonClicked(sender: UIButton)
    {
        forgotPasswordRequest()
    }
    
    
    // MARK:- Forgot Password Request Methods
    
    func forgotPasswordRequest()
    {
        self.view.endEditing(true)
        let request = ForgotPassword.Request(email: emailTextField.text_Trimmed().lowercased())
        interactor?.forgotPasswordRequest(request: request)
    }
    
    
    // MARK:- Forgot Password Response Methods
    
    func displayForgotPasswordResponse(viewModel: ForgotPassword.ViewModel) {
        
        if viewModel.error != nil {
           CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
           CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
           router?.navigateBack()
        }
    }

    
    
    //MARK:- Helper Methods
    
    func setUpUIDesign()
    {
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: OnBoardingModuleText.ForgotPasswordButtonTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        emailTextField.placeholder = localizedTextFor(key: OnBoardingModuleText.EmailAddressPlaceholder.rawValue)
        
        submitButton.setTitle(localizedTextFor(key: OnBoardingModuleText.SubmitButtonTitle.rawValue), for: .normal)
        submitButton.layer.cornerRadius = submitButton.frame.size.height/2.0
        submitButton.clipsToBounds = true
    }
}

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
        
    }
}
