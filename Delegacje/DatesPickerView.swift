//
//  DatesPickerView.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 28/02/2021.
//

import UIKit

class DatesPickerView: UIView {
    
    let k_CONTENT_XIB_NAME = "DatesPickerView"
    @IBOutlet var datesView: UIView!
    @IBOutlet weak var firstDatePicker: UIDatePicker!
    @IBOutlet weak var secondDatePicker: UIDatePicker!
    var tappedClosure: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(k_CONTENT_XIB_NAME, owner: self, options: nil)
        datesView.fixInView(self)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        tappedClosure?()
    }
    
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
