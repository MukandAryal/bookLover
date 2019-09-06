
import UIKit

class UIButtonFontSize: UIButton {

    override func awakeFromNib() {
        // self.font = UIFont.init(name: "", size: self.font.pointSize)
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.titleLabel?.font.pointSize
        let fontDescriptor = self.titleLabel?.font.fontDescriptor
        if (TotalWidth == 375){
            self.titleLabel?.font = UIFont(descriptor: fontDescriptor!, size: currentSize!-1)
        }
        else if (TotalWidth == 320){
            self.titleLabel?.font = UIFont(descriptor: fontDescriptor!, size: currentSize!-2)
        }
    }

}
