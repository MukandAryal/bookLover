

import UIKit

protocol SettingsBusinessLogic
{

}

protocol SettingsDataStore
{
  //var name: String { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore
{
  var presenter: SettingsPresentationLogic?
  var worker: SettingsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
}
