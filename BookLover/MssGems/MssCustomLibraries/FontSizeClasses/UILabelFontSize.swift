
import UIKit

class UILabelFontSize: UILabel {
    
    override func awakeFromNib() {
       //self.font = UIFont(name:"Arial", size: self.font.pointSize)
       // printToConsole(item: "Font NAme -- \(self.font)")
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font.pointSize
        if (TotalWidth == 375){
            self.font = self.font.withSize(currentSize-1)
        }
        else if (TotalWidth == 320){
            self.font = self.font.withSize(currentSize-2)
        }
    }
}
