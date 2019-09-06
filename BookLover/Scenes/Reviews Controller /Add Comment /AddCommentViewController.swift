

import UIKit

protocol AddCommentDisplayLogic: class
{
    func displayAddCommentResponse(viewModel: AddComment.ViewModel)
}

class AddCommentViewController: UIViewController, AddCommentDisplayLogic
{
    var interactor: AddCommentBusinessLogic?
    var router: (NSObjectProtocol & AddCommentRoutingLogic & AddCommentDataPassing)?
    
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
        let interactor = AddCommentInteractor()
        let presenter = AddCommentPresenter()
        let router = AddCommentRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: Outlet
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblAddyourComment: UILabelFontSize!
    @IBOutlet weak var lblWriteYourComment: UILabelFontSize!
    @IBOutlet weak var txtViewAddComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButtonFontSize!
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setUpInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtViewAddComment.resignFirstResponder()
        self.navigationController?.navigationBar.isHidden = false

    }
    
    func setUpInterface(){
        
        txtViewAddComment.tintColor = UIColor.white
        txtViewAddComment.becomeFirstResponder()
        lblAddyourComment.text = localizedTextFor(key: UserReviewText.AddYourComment.rawValue)
        lblWriteYourComment.text = localizedTextFor(key: AddCommentText.WriteYourCommentHere.rawValue)
        btnSubmit.setTitle(localizedTextFor(key:AddCommentText.AddCommentSubmit.rawValue), for:.normal)
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2
        btnSubmit.clipsToBounds = true
    }
    
    func displayAddCommentResponse(viewModel: AddComment.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
           
            txtViewAddComment.text = ""
            self.dismiss(animated: true, completion: {
            })
        }
    }
    
    @IBAction func actionAddComment(_ sender: Any) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            let requestAddComment = AddComment.Request(description: txtViewAddComment.text_Trimmed())
            interactor?.addCommentApi(request: requestAddComment)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//    self.navigationController?.popViewController(animated: true)
//
    }
}
