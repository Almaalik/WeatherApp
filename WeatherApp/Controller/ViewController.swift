//
//  ViewController.swift
//  WeatherApp
//
//  Created by macbook  on 30/05/21.
//  Copyright © 2021 Almaalik. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var model = [Daily]()
    var temperature : Double = 0.0
    var timeZoneData : String = ""
    var currentDate : Double = 0.0
    var descriptionData : String = ""
    var conditionId : Int = 0
    var imgName : String = ""
    var url2 : String = ""
    var cityName : String = ""
    
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    // Location Details
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.startUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    //API Call for fetching Weather Details from Open WeatherMap
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,hourly,alerts&appid=aaa378e239c2915a1fc61b6528616289"
        
        self.url2 = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=aaa378e239c2915a1fc61b6528616289"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            //Validation
            
            guard let data = data, error == nil else {
                print("somrthing went wrong fetctching WeatherForLocation")
                return
            }
            
            //Converting data to models
            
            var json : WeatherData?
            do {
                json = try JSONDecoder().decode(WeatherData.self, from: data)
            } catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            
            let dailyWeather = result.daily
            
            //Assigning the Decode value to  Local Variables
            
            self.timeZoneData = result.timezone
            self.currentDate = result.current.dt
            self.temperature = result.current.temp
            self.descriptionData = result.current.weather[0].description
            self.conditionId = result.current.weather[0].id
         
            
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
            
            self.model.append(contentsOf: dailyWeather)
            
            //   updateing UI
            
            DispatchQueue.main.async {
                self.locatioName()
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
            
        }) .resume()
    }
    
    // API Call for fetching current location Name
    
    func locatioName() {
        
        URLSession.shared.dataTask(with: URL(string: url2)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("somrthing went wrong in Fetching Location Name")
                return
            }
            //Convert data to models
            
            var json : LocationName?
            do {
                json = try JSONDecoder().decode(LocationName.self, from: data)
            } catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            
            self.cityName = result.name
            
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }) .resume()
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        print("Refereshing to upload...")
        self.table.reloadData()
        locationManager.startUpdatingLocation()
        
        
    }
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.confugure(with: model[indexPath.row])
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    // Table HeaderView
    
    func createTableHeader() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width/1.5))
        headerView.backgroundColor = UIColor(red: 128/255.0, green: 210/255.0, blue: 250/255.0, alpha: 1.0)
        
        headerView.layer.cornerRadius = 8
        headerView.layer.masksToBounds = true
        
        let width = view.frame.size.width
        let Headerheight = headerView.frame.size.height
        
        
        let locationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: Headerheight/6))
        
        let button = UIButton(frame: CGRect(x: width/1.5 + width/5 , y: 0, width: width/10, height: Headerheight/6))
        
        let conditionImg = UIImageView(frame: CGRect(x: width/2.5, y: Headerheight/3.5, width: width/2, height: Headerheight/2))
        
        let dayLabel = UILabel(frame: CGRect(x: 5, y: Headerheight/5, width: width/3, height: Headerheight/6))
        
        
        let tempLabel = UILabel(frame: CGRect(x: 25, y: Headerheight/2.4 , width: width/4, height:  Headerheight/2.5))
        
        let dateLabel = UILabel(frame: CGRect(x: 10, y: Headerheight/1.6 + 50, width: width/2.5, height: Headerheight/7))
        
        let summaryLabel = UILabel(frame: CGRect(x: width/2, y: Headerheight/1.6 + 50, width: width/2.5, height: Headerheight/7))
        
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(button)
        headerView.addSubview(conditionImg)
        headerView.addSubview(dayLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(summaryLabel)
        
        locationLabel.backgroundColor = .black
        locationLabel.textColor = .white
        dayLabel.textAlignment = .center
        dayLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.textColor = .white
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = .white
        
        conditionImg.tintColor = .white
        conditionImg.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .heavy)
        button.tintColor = .white
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 45)
        locationLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        dayLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        dateLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        summaryLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        
        //Converting Temperature Data from Kelvin to Celsius
        
        let final = String(format: "%.0f", temperature - 273.15)
        
        //Converting Data
        
        func getDay(_ date: Date?) -> String{
            guard let frominputDay = date else {
                return ""
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: frominputDay)
        }
        
        let finalDate = getDay(Date(timeIntervalSince1970: Double(currentDate)))
        
        func getData(_ date: Date?) -> String{
            guard let fromdata = date else {
                return ""
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: fromdata)
        }
        
        let finalDay = getData(Date(timeIntervalSince1970: Double(currentDate)))
        
        //Updating the UI with Decoded Datas
        
        locationLabel.text = "  \(cityName)"
        conditionImg.image = UIImage(systemName: imgName)
        dateLabel.text = finalDay
        tempLabel.text = "\(final)℃"
        dayLabel.text = finalDate
        summaryLabel.text = descriptionData
        
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return headerView
    }
    
}

