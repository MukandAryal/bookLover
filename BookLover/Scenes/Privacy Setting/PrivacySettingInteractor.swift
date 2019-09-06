
import UIKit

protocol PrivacySettingBusinessLogic
{
}

protocol PrivacySettingDataStore
{
  //var name: String { get set }
}

class PrivacySettingInteractor: PrivacySettingBusinessLogic, PrivacySettingDataStore
{
  var presenter: PrivacySettingPresentationLogic?
  var worker: PrivacySettingWorker?

}
