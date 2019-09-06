/**
 This class contains various useful extension of UIKit objects
 */
import UIKit

extension UIApplication {
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


extension UITextField {
    
    /**
     This extension always return the trimmed text from the text field.
     
     ### Usage Example: ###
     ````
     textfieldInstance.trimmedText()
     ````
     */
    
    func text_Trimmed() -> String {
        if let actualText = self.text {
            return actualText.trimmingCharacters(in: .whitespaces)
        }
        else {
            return ""
        }
    }
    
    /**
     This extension adds done button on UITextfield keyboards where there is no default button (eg. number pad, phone pad, custom pickers etc.).
     */
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: localizedTextFor(key: "Done"), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UIViewController {
    
    /**
     This extension hides the text written with the back button of the naviagtion bar.
     */
    
    func hideBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension String {
    
    /**
     This extension converts the string into boolean.
     */
    
    func boolValue() -> Bool {
        let nsString = self as NSString
        return nsString.boolValue
    }
    
    /**
     This extension converts the string into Integer.
     */
    
    func intValue() -> Int {
        let nsString = self as NSString
        return nsString.integerValue
    }
    
    /**
     This extension checks whether the string is empty
     */
    
    func isEmptyString() -> Bool {
        if self == "" {
            return true
        }
        else {
            return false
        }
    }
    
    func underLine(color: UIColor?, font: UIFont?) -> NSAttributedString {
        
        let attribute = [
            NSAttributedStringKey.font : font as Any,
            NSAttributedStringKey.foregroundColor : color as Any,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let attributedString = NSAttributedString(string: self, attributes: attribute)
        
        return attributedString
    }
   
    func attributedStringWithColor( _ color : UIColor, subString: String ) -> NSAttributedString {
        
        var attrStr = NSMutableAttributedString(string: self)
        if let range = self.range(of: subString) {
            //attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color as Any, range: range)
        }
        return attrStr
    }
    
    var containsEmoji: Bool {
        
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
    
        
    
}

extension UIView {
    @IBInspectable var bottomShadowColor: UIColor{
        get{
            let color = layer.shadowColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        set {
            addBottomShadow(color: bottomShadowColor)
        }
    }
    
    func addBottomShadow(color:UIColor) {
        let shadowColor = color.cgColor
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

extension UIScrollView {
    
    /**
     This extension manages the keyboard. This will work correctly only if the constraints are placed properly in storyboard.
     ### Usage Example: ###
     ````
     scrollViewInstance.manageKeyboard()
     ````
     */
    
    func manageKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.akeyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.akeyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func akeyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var contentInset:UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.contentInset = contentInset
    }
    
    @objc func akeyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contentInset = contentInset
    }
}

extension UITextView {
    
    /**
     This extension always return the trimmed text from the text view.
     
     ### Usage Example: ###
     ````
     textfieldInstance.trimmedText()
     ````
     */
    
    func text_Trimmed() -> String {
        if let actualText = self.text {
            return actualText.trimmingCharacters(in: .whitespaces)
        }
        else {
            return ""
        }
    }
    
    /**
     This extension adds done button on UITextview keyboards where there is no default button (eg. number pad, phone pad, custom pickers etc.).
     */
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: localizedTextFor(key: "Done"), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    init(largeMilliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(largeMilliseconds / 1000))
    }
    
    /**
     Call this function to generate string representation of date
     */
    
    
    
    /**
     Call this function to generate date representation of string
     */
    
    
    
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

extension UITabBarController {
    
    func setTabBarVisible(visible:Bool) {
        setTabBarVisible(visible: visible, duration: 0, animated: false)
    }
    
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            let width = self.view.frame.width
            let height = self.view.frame.height + offsetY
            self.view.frame = CGRect(x:0, y:0, width: width, height: height)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}

extension Double {
//    
//    func convertToString(withFormat: format) -> String {
//        //   String(format: "%.1f", "\(Float((withData.rating!)))")
//        let floatV = Float(self)
//        return String(format: "%.\(decimalPlaces))f", "\(floatV)")
//    }
    
}



