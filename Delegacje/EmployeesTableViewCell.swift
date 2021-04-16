//
//  EmployeesTableViewCell.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/02/2021.
//

import UIKit

class EmployeesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeSurnameLabel: UILabel!
    @IBOutlet weak var employeeEmailLabel: UILabel!
    @IBOutlet weak var numberOfDelegationsLabel: UILabel!
    
    var model: User! {
        didSet {
            customize(model: model)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        contentView.layer.cornerRadius = 20
    }
    
    func customize(model: User) {
        let firstName = model.fullName.components(separatedBy: " ")[0]
        let surname = model.fullName.components(separatedBy: " ")[1]
        employeeNameLabel.text = firstName
        employeeSurnameLabel.text = surname
        employeeEmailLabel.text = model.email
        numberOfDelegationsLabel.text = String(model.numberOfDelegations ?? 0)
    }

}
