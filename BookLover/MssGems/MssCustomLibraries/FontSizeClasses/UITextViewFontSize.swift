
import UIKit

class UITextViewFontSize: UITextView {

    override func awakeFromNib() {
        // self.font = UIFont.init(name: "", size: self.font.pointSize)
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font!.pointSize
        if (TotalWidth == 375){
            self.font = self.font!.withSize(currentSize-1)
        }
        else if (TotalWidth == 320){
            self.font = self.font!.withSize(currentSize-2)
        }
    }

}
