//
//  DelegationTableViewCell.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 29/12/2020.
//

import UIKit

class DelegationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var departurePlaceLabel: UILabel!
    @IBOutlet weak var arrivalPlaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    
    var model: Delegation! {
        didSet {
            customize(model: model)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        contentView.layer.cornerRadius = 20
        setBackgroundImage()
    }
    
    func setBackgroundImage() {
        var imageView = UIImageView(frame: self.contentView.frame)
        imageView.image = UIImage(named: "bluewave.png")
    }
    
    func customize(model: Delegation) {
        //TODO: Date ranges and prices and car model and brand
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        let departureDate = dateFormatter.string(from: model.departureDate)
        let arrivalDate = dateFormatter.string(from: model.arrivalDate)
        dateRangeLabel.text = departureDate + " - " + arrivalDate
        departurePlaceLabel.text = model.departurePlace
        arrivalPlaceLabel.text = model.arrivalPlace
        distanceLabel.text = String(model.distance) + " km"
        if let car = model.car {
            priceLabel.text = String(round(model.distance * car.ryczalt * 100)/100) + " zł"
            carModelLabel.text = car.brand + " " + car.model
        }
        if let user = model.user {
            employeeNameLabel.text = user.fullName
        }
    }

}
