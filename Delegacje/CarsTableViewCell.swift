//
//  CarsTableViewCell.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 06/01/2021.
//

import UIKit

class CarsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carBackgroundImageView: UIImageView!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carCapacityLabel: UILabel!
    @IBOutlet weak var carProductionYearLabel: UILabel!
    @IBOutlet weak var carRyczaltLabel: UILabel!
    @IBOutlet weak var carStawkaLabel: UILabel!
    
    var model: Car! {
        didSet {
            customize(car: model)
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
    }
    
    //TODO: Jesli auto jest uzywane to zmienic kolor tego zdjecia w tle na czerwone, jesli jest wolne to zostawic zielone
    
    func customize(car: Car) {
        carModelLabel.text = car.brand + " " + car.model
        carCapacityLabel.text = "Pojemność silnika: " + String(round(car.capacity * 10)/10)
        carProductionYearLabel.text = "Rocznik: " + String(car.productionYear)
        carRyczaltLabel.text = "Ryczałt: " + String(round(car.ryczalt * 100)/100) + "zł"
        carStawkaLabel.text = "Stawka: " + String(round(car.stawka * 100)/100) + "zł"
        
        if car.inUse == true {
            carBackgroundImageView.tintColor = .red
        } else {
            carBackgroundImageView.tintColor = .green
        }
    }

}
