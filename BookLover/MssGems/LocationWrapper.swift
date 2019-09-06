
import UIKit
import CoreLocation


class LocationWrapper: NSObject {
    
    static let sharedInstance = LocationWrapper()
    
    let locationManager = CLLocationManager()
    var latitude:Double = 0.0
    var longitude:Double = 0.0

    func fetchLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationManager.startUpdatingLocation()
        }
        else {
            showPermissionAlert()
        }
    }
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationManager.startUpdatingLocation()
        }
    }
    
    func showPermissionAlert() {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: GeneralText.permissionHeading.rawValue), description: localizedTextFor(key: GeneralText.gpsPermission.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        appDelegateObj.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension LocationWrapper:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationCoordinate = locations.last?.coordinate {
            manager.delegate = nil
            manager.stopUpdatingLocation()
            self.longitude = locationCoordinate.longitude
            self.latitude = locationCoordinate.latitude
        }
        locationManager.stopUpdatingLocation()
    }
}
