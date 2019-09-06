
import UIKit

protocol DeleteAccountDisplayLogic: class
{
    func displayDeleteAccountResponse(viewModel: DeleteAccount.ViewModel)
}

class DeleteAccountViewController: UIViewController, DeleteAccountDisplayLogic
{
    var interactor: DeleteAccountBusinessLogic?
    var router: (NSObjectProtocol & DeleteAccountRoutingLogic & DeleteAccountDataPassing)?
    var callDismissedAction : DeleteCompletion?
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
        let interactor = DeleteAccountInteractor()
        let presenter = DeleteAccountPresenter()
        let router = DeleteAccountRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Outlet ---
    
    @IBOutlet weak var lblDeleteAccount: UILabelFontSize!
    @IBOutlet weak var lblAleatMessage: UILabelFontSize!
    @IBOutlet weak var btnConfromDelete: UIButtonFontSize!
    
    // MARK: viewDidLoad ---
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: viewWillAppear  --
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.callDismissedAction!(false)
    }

     // MARK: Class Helper --
    func setUpInterface(){
        btnConfromDelete.layer.cornerRadius = btnConfromDelete.frame.size.height/2.0
        btnConfromDelete.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Display Response --
    func displayDeleteAccountResponse(viewModel: DeleteAccount.ViewModel) {
        if let error = viewModel.error{
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }else{
            
            CommonFunctions.sharedInstance.removeUserData()
            CommonFunctions.sharedInstance.navigateLoginVC()
        }
    }
    // MARK: Button Action --
    @IBAction func actionDeleteAccount(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.callDismissedAction!(true)
        })
    }
    @IBAction func actionDelete(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.callDismissedAction!(false)
        })
    }
}
