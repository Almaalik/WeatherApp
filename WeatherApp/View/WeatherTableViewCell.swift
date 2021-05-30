//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by macbook  on 30/05/21.
//  Copyright © 2021 Almaalik. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    
    var conditionId : Int = 0
    var imgName : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func confugure(with model:  Daily) {
        
        let averageTemp = ((model.temp.max) + (model.temp.min)) / 2
        let temperature =  String(format: "%.0f", averageTemp - 273.15)
        self.tempLabel.text = "\(temperature)℃"
        
        self.dayLabel.text = getDayForData(Date(timeIntervalSince1970: Double(model.dt)))
        self.conditionId = model.weather[0].id
        self.iconImageView.image = UIImage(systemName: imgName)
        
        // Weather condition Images
        
        switch self.conditionId {
        case 200...232:
            self.imgName = "cloud.bolt.fill"
        //Thunderstorm
        case 300...321:
            self.imgName = "cloud.drizzle.fill"
            //Drizzle
            
        case 500...531:
            self.imgName = "cloud.heavyrain.fill"
            //Rain
            
        case 600...622:
            self.imgName =  "snow"
            //Snow
            
        case 701...781:
            self.imgName = "smoke.fill"
            //Atmosphere
            
        case 800:
            self.imgName = "cloud.sun.fill"
            //Clear
            
        case 801...804:
            self.imgName =  "cloud.fill"
            //Clouds
            
        default:
            self.imgName = "sun.max.fill"
            
        }
        
    }
    
    //Day Foramting
    
    func getDayForData(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
        
    }
    
}

