

import UIKit
import Alamofire

protocol getFilterData {
    func setFiltersData(_ obj: [String: Any])
}

class FilterViewController: UIViewController,getAgeData {
    
    @IBOutlet weak var viewMaleFemale: UIView!
    @IBOutlet weak var btnMale: UIButtonFontSize!
    @IBOutlet weak var btnFemale: UIButtonFontSize!
    @IBOutlet weak var btnSubmit: UIButtonFontSize!
    @IBOutlet weak var lblFilterBy: UILabelFontSize!
    @IBOutlet weak var lblByAge: UILabelFontSize!
    @IBOutlet weak var btnReset: UIButtonFontSize!
    @IBOutlet weak var lblByGender: UILabelFontSize!
    @IBOutlet weak var lblCountry: UILabelFontSize!
    @IBOutlet weak var btnCountry: UIButtonFontSize!
    @IBOutlet weak var lblState: UILabelFontSize!
    @IBOutlet weak var btnState: UIButtonFontSize!
    @IBOutlet weak var lblAge: UILabelFontSize!
    @IBOutlet weak var btnAge: UIButtonFontSize!
    
    var isFilter :  Bool? = true
    var strCountryId: String?
    var isSelected : Int = 0
    var gender : String = ""
    var ageArray = [Int]()
    var nearMe: String = ""
    var countryName: String = ""
    var stateName: String = ""
    
    var delegate: getFilterData?
    var ageObj: [String: Any]?
    var filtersObj: [String: Any]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpInterface()
        setFilterSelected()
        countryListData()
    }
    
    func countryListData()
    {
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.country, httpMethod: .get) { (response) in
            if response.code == SuccessCode {
                let data = response.result as! NSDictionary
                if let list = (data["countries"] as? [[String:Any]]) {
                    let resultData = NSKeyedArchiver.archivedData(withRootObject: list)
                    userDefault.set(resultData, forKey: userDefualtKeys.countryList.rawValue)
                }
            }
        }
//        worker = CompleteProfileWorker()
//        worker?.hitCountryApi(apiResponse: { (response) in
//            let data = response.result as! NSDictionary
//            if let list = (data["countries"] as? [[String:Any]]) {
//                let resultData = NSKeyedArchiver.archivedData(withRootObject: list)
//                userDefault.set(resultData, forKey: userDefualtKeys.countryList.rawValue)
//            }
//        })
    }
    
    func setAgData(_ obj: [String: Any]){
        ageObj = obj
        printToConsole(item: obj)
        ageArray = (ageObj!["age"] as! NSArray) as! [Int]
        let ageStart = ageArray[0]
        let ageEnd = ageArray[1]
        if ageStart == 75 {
            btnAge.setTitle("75+", for: .normal)
        }else{
            let selectAge = ageStart.description + "," + ageEnd.description
            printToConsole(item: selectAge)
            let showAge = ageStart.description + "-" + ageEnd.description
            btnAge.setTitle(showAge, for: .normal)
        }
        
//        let selectAge = ageStart.description + "," + ageEnd.description
//        printToConsole(item: selectAge)
//        btnAge.setTitle(selectAge, for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        isSelected = -1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setFilterSelected(){
        if filtersObj != nil {
            let getGender = filtersObj!["isGender"] as! String
            if  getGender == localizedTextFor(key: FilterAgeText.Male.rawValue)  {
                btnMale.backgroundColor = UIColor(red: 242/255.0, green: 223/255.0, blue: 1/255.0, alpha: 1.0)
            }else if getGender == localizedTextFor(key: FilterAgeText.Female.rawValue){
                btnFemale.backgroundColor = UIColor(red: 242/255.0, green: 223/255.0, blue: 1/255.0, alpha: 1.0)
            }else {
                btnMale.backgroundColor = UIColor.black
                btnFemale.backgroundColor = UIColor.black
            }
            let GetCountry = filtersObj!["country"] as! String
            if GetCountry == "" {
                btnCountry.setTitle("", for:.normal)
            }else{
                btnCountry.setTitle(GetCountry, for:.normal)
            }
            let GetState = filtersObj!["state"] as! String
            if GetState == "" {
                btnState.setTitle("", for:.normal)
            }else{
                btnState.setTitle(GetState, for:.normal)
            }
            let strcountryId = filtersObj!["strCountryId"] as! String
            if strCountryId == ""{
            }else{
                strCountryId = strcountryId
            }
            ageArray = (filtersObj!["age"] as! NSArray) as! [Int]
            if ageArray.count > 0 {
                let ageStart = ageArray[0]
                if ageStart == 75{
                    btnAge.setTitle("75+", for: .normal)
                }
                else{
                    let ageEnd = ageArray[1]
                    let selectAge = ageStart.description + "-" + ageEnd.description
                    btnAge.setTitle(selectAge, for: .normal)
                }
            }
        }
    }
    
    func setUpInterface() {
        viewMaleFemale.layer.cornerRadius = viewMaleFemale.frame.size.height/2.0
        viewMaleFemale.clipsToBounds = true
        
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2.0
        btnSubmit.clipsToBounds = true
        
        lblFilterBy.text = localizedTextFor(key:FilterAgeText.byFiler.rawValue)
        lblByAge.text = localizedTextFor(key:FilterAgeText.ByAge.rawValue)
        lblByGender.text = localizedTextFor(key:FilterAgeText.ByGender.rawValue)
        
        lblByGender.text = localizedTextFor(key:FilterAgeText.ByGender.rawValue)
        
        btnReset.setTitle(localizedTextFor(key: FilterAgeText.Reset.rawValue), for:.normal)
        btnMale.setTitle(localizedTextFor(key: FilterAgeText.Male.rawValue), for:.normal)
        btnFemale.setTitle(localizedTextFor(key: FilterAgeText.Female.rawValue), for:.normal)
        
        btnSubmit.setTitle(localizedTextFor(key: FilterAgeText.Apply.rawValue), for:.normal)
        lblCountry.text = localizedTextFor(key:FilterAgeText.Country.rawValue)
        lblState.text = localizedTextFor(key:FilterAgeText.State.rawValue)
        
        btnState.setTitle("", for: .normal)
        btnCountry.setTitle("", for: .normal)
    }
    
    
    func presenterCountryDismisedAction() -> CountryCompletion {
        
        return { [unowned self] data in
            if data != nil {
                self.strCountryId = "\((data!["id"] as? Int16)!)"
                self.btnCountry.setTitle((data!["name"] as? String), for: .normal)
                self.btnState.setTitle("", for: .normal)
                self.countryName = (data!["name"] as? String)!
            }else{
                return
            }
        }
    }
    
    func presenterStateDismisedAction() -> StateCompletion {
        
        return { [unowned self] data in
            if data != nil {
                self.btnState.setTitle(data!.name, for: .normal)
                self.stateName = (data!.name)!
            } else {
                return
            }
        }
    }
    
    
    func navigateToAddFriend(isFilter:Bool,isGender:String,nearMe:String,age:[Int],country:String,state:String,strCountryId :String){
        let filtersObj = ["isFilter":isFilter,"isGender":isGender,"nearMe":nearMe,"age":age,"country":country,"state":state,"strCountryId":strCountryId] as [String : Any]
        delegate?.setFiltersData(filtersObj)
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: Passing data
    
    func passDataToShowOrder(destination: inout AddFriendDataStore,isFilter:Bool,isGender:String,nearMe:String,age:[Int],country:String,state:String)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionMale(_ sender: Any) {
        btnMale.backgroundColor = UIColor(red: 242/255.0, green: 223/255.0, blue: 1/255.0, alpha: 1.0)
        btnFemale.backgroundColor = UIColor.black
        gender = localizedTextFor(key: FilterAgeText.Male.rawValue)
    }
    @IBAction func actionFemale(_ sender: Any) {
        btnMale.backgroundColor = UIColor.black
        btnFemale.backgroundColor = UIColor(red: 242/255.0, green: 223/255.0, blue: 1/255.0, alpha: 1.0)
        gender = localizedTextFor(key: FilterAgeText.Female.rawValue)
    }
    
    @IBAction func actionResetAge(_ sender: Any) {
        filtersObj?.removeAll()
        ageObj?.removeAll()
        strCountryId = nil
        gender = ""
        countryName = ""
        stateName = ""
        btnCountry.isEnabled = true
        btnState.isEnabled   = true
        btnCountry.setTitle("", for: .normal)
        btnState.setTitle("", for: .normal)
        btnAge.setTitle("", for: .normal)
        ageArray .removeAll()
        isSelected = -1
        btnMale.backgroundColor = UIColor.black
        btnFemale.backgroundColor = UIColor.black
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        navigateToAddFriend(isFilter:isFilter!, isGender: gender, nearMe: nearMe, age: ageArray, country: countryName, state: stateName,strCountryId: strCountryId ?? "")
    }
    
    
    @IBAction func actionCountry(_ sender: Any) {
        let vcObj = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Country) as? CountryViewController
        vcObj?.callbackDismiss = presenterCountryDismisedAction()
        let navCountry = UINavigationController(rootViewController: vcObj!)
        self.present(navCountry, animated: true, completion: nil)
    }
    
    
    @IBAction func actionState(_ sender: Any) {
        
        if strCountryId != nil {
            hitStateApi()
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: CompleteProfileValidationText.SelectCountryFirst.rawValue))
        }
        
    }
    @IBAction func ActionAge(_ sender: Any) {
        let vcObj = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.AgeSelect) as? AgeSelectViewController
        let navCountry = UINavigationController(rootViewController: vcObj!)
        vcObj?.delegate = self
        self.present(navCountry, animated: true, completion: nil)
    }
    
    @IBAction func actionCross(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    func hitStateApi() {
        
        let endUrl = ApiEndPoints.state + strCountryId! + ".json"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get) { (response) in
            if response.code == SuccessCode {
                
                var stateList = [CompleteProfile.ViewModel.StateData]()
                
                let data = response.result as! NSDictionary
                
                if let list = (data["states"] as? [[String:Any]]) {
                    
                    for obj in list {
                        
                        let stateData = CompleteProfile.ViewModel.StateData(
                            id: obj["id"] as? Int16,
                            name: obj["name"] as? String,
                            country_id: obj["country_id"] as? Int16)
                        stateList.append(stateData)
                    }
                }
                
                let vcObj = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.State) as? StateViewController
                vcObj?.callbackDismiss = self.presenterStateDismisedAction()
                vcObj?.arrStateList = stateList
                let navCountry = UINavigationController(rootViewController: vcObj!)
                self.present(navCountry, animated: true, completion: nil)
                
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
}
