

import UIKit
import Cosmos

protocol RatingDisplayLogic: class
{
    func displayWriteRatingResponse(viewModel: Rating.ViewModel)
    func displayReviewResponse(rating: Double, description: String, isRatingEdit: Bool)
}

class RatingViewController: UIViewController, RatingDisplayLogic
{
    var interactor: RatingBusinessLogic?
    var router: (NSObjectProtocol & RatingRoutingLogic & RatingDataPassing)?
    
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
        let interactor = RatingInteractor()
        let presenter = RatingPresenter()
        let router = RatingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Outet Helper --
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblRateAndReview: UILabelFontSize!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblWriteYourComment: UILabelFontSize!
    @IBOutlet weak var txtViewAddComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButtonFontSize!
    var isEdit = Bool()
    // MARK: View lifecycle
    
    // MARK: viewDidLoad Helper --
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: viewWillAppear Helper --

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setUpInterface()
        interactor?.getReviewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtViewAddComment.resignFirstResponder()
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    // MARK: setUpInterface Helper --
    func setUpInterface(){
        
        txtViewAddComment.tintColor = UIColor.white
        ratingView.settings.fillMode = .full
        txtViewAddComment.becomeFirstResponder()
        lblRateAndReview.text = localizedTextFor(key:RateAndReviewText.RateAndReviewThisBook.rawValue)
        lblWriteYourComment.text = localizedTextFor(key: RateAndReviewText.WriteYourReview.rawValue)
        btnSubmit.setTitle(localizedTextFor(key:RateAndReviewText.RateAndReviewSubmit.rawValue), for:.normal)
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2
        btnSubmit.clipsToBounds = true
    }
    
    // MARK: Display Response Helper --
    
    
    func displayReviewResponse(rating: Double, description: String, isRatingEdit: Bool)
        
    {
        ratingView.rating = rating
        txtViewAddComment.text = description
        isEdit = isRatingEdit
    }
    
    func displayWriteRatingResponse(viewModel: Rating.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
           
            ratingView.text = ""
            txtViewAddComment.text = ""
            self.dismiss(animated: true, completion: {
                if self.isEdit {
                    CustomAlertController.sharedInstance.showSuccessAlert(success: localizedTextFor(key: SucessfullyMessage.Revieweditedsucessfully.rawValue))
                } else {
                    CustomAlertController.sharedInstance.showSuccessAlert(success:localizedTextFor(key: SucessfullyMessage.Addratingsucessfully.rawValue))
                }
              
            })
        }
    }
    
    // MARK: Button Action Helper --
    @IBAction func actionSubmit(_ sender: Any) {
        if isEdit {
            let ratingRequest = Rating.Request(rating:ratingView.rating.description, description: txtViewAddComment.text_Trimmed())
            interactor?.editWriteRatingApi(request: ratingRequest)
            
        }
        else {
            let ratingRequest = Rating.Request(rating:ratingView.rating.description, description: txtViewAddComment.text_Trimmed())
            printToConsole(item: ratingRequest)
            interactor?.writeRatingApi(request: ratingRequest)
        }
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

