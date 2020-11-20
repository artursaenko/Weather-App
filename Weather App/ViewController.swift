//
//  ViewController.swift
//  Weather App
//
//  Created by Artur Saenko on 19/11/2020.
//  Copyright © 2020 Artur Saenko. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!

    private var activityIndicator: UIActivityIndicatorView!
    private var gradientLayer: CAGradientLayer!
    private var locationManager: CLLocationManager!
    
    private let endPoint = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "9d7703288d524044d5692061d93601e1"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        setViewsHidden(true)
        setupActivityIndicator()
        setupLocationManager()
    }
    
    private func loadWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        guard
            let url = URL(string: "\(endPoint)weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")
        else { return }
        URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                    print(model)
                    DispatchQueue.main.async {
                        self.cityLabel.text = model.city
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, EEEE"
                        self.dateLabel.text = dateFormatter.string(from: Date())
                        switch model.condition.first!.main {
                        case .clear:
                            self.weatherImageView.image = UIImage(named: "Sun")?.withRenderingMode(.alwaysTemplate)
                        case .clouds:
                            self.weatherImageView.image = UIImage(named: "PartlySunny")?.withRenderingMode(.alwaysTemplate)
                        case .drizzle, .rain:
                            self.weatherImageView.image = UIImage(named: "Rain")?.withRenderingMode(.alwaysTemplate)
                        case .thunderstorm:
                            self.weatherImageView.image = UIImage(named: "Storm")?.withRenderingMode(.alwaysTemplate)
                        case .snow:
                            self.weatherImageView.image = UIImage(named: "Snow")?.withRenderingMode(.alwaysTemplate)
                        case .mist:
                            self.weatherImageView.image = UIImage(named: "Haze")?.withRenderingMode(.alwaysTemplate)
                        }
                        self.weatherConditionLabel.text = model.condition.first!.main.rawValue
                        self.degreeLabel.text = "\(round(model.temperature.real))℃"
                        self.setViewsHidden(false)
                    }
                } catch let error {
                    showAlert(error)
                }
            }
            if let error = error {
                showAlert(error)
            }
        }.resume()
    }

    private func setupGradient() {
        let colorTop =  UIColor(red: 0.07, green: 0.13, blue: 0.33, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.56, green: 0.4, blue: 0.62, alpha: 1.0).cgColor
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            activityIndicator.startAnimating()
        }
    }

    private func setViewsHidden(_ hidden: Bool) {
        cityLabel.isHidden = hidden
        dateLabel.isHidden = hidden
        weatherImageView.isHidden = hidden
        weatherConditionLabel.isHidden = hidden
        degreeLabel.isHidden = hidden
    }
        
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    private func showAlert(_ error: Error) {
        print(error)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let location = locations.last else { return }
        loadWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(error)
    }
}
