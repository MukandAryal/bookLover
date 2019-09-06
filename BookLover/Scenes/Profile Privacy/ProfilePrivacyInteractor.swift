
import UIKit

protocol ProfilePrivacyBusinessLogic
{
}

protocol ProfilePrivacyDataStore
{
  //var name: String { get set }
}

class ProfilePrivacyInteractor: ProfilePrivacyBusinessLogic, ProfilePrivacyDataStore
{
  var presenter: ProfilePrivacyPresentationLogic?
  var worker: ProfilePrivacyWorker?
 
}
