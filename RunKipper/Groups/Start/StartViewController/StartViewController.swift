//
//  ViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 12/18/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class StartViewController: UIViewController {
    // - UI
    @IBOutlet weak var locationsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    // - Data
    let locationManager = CLLocationManager()
    //let motionManager = CMMotionActivityManager()
    private var weatherArray = [WeatherModel]()
    var myLocationss = [CLLocation]()
    var generalDistance = 0.0
    var generalTime = 0.0
    
    // - Snow&Rain Layer
    var rainEmitterLayer = CAEmitterLayer()
    let rainEmitterCell = CAEmitterCell()
    let blurryRainEmitterCell = CAEmitterCell()
    var snowEmitterLayer = CAEmitterLayer()
    let flakeEmitterCell = CAEmitterCell()
    let blurryFlakeEmitterCell = CAEmitterCell()
    
    // - Path
    let path = GMSMutablePath()
    
    // - MyLocation
    var myLocationLatitude: Double!
    var myLocationLongitude: Double!
    
    // - Weather
    var temp = 0.0
    var main = ""
    var discription = ""
    var countOfLaunch = 0
    var dateSec = 0
    let nightColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
    let daySunColor = UIColor.systemTeal
    let dayCloudsColor = UIColor(red: 34/255, green: 118/255, blue: 250/255, alpha: 1)
    
    // - Session
    let session = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func configure() {
        configureMap()
        configureDate()
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        let runVC = UIStoryboard(name: "Run", bundle: nil).instantiateInitialViewController() as! RunViewController
        runVC.modalPresentationStyle = .overFullScreen
        locationManager.stopUpdatingLocation()
        present(runVC, animated: true)
    }
    
}

// MARK: -
// MARK: - Snow&Rain func
private extension StartViewController {
    func addRain() {
        rainEmitterLayer.emitterPosition = CGPoint(x: weatherView.frame.width, y: 0)
        rainEmitterLayer.emitterSize = weatherView.bounds.size
        weatherView.clipsToBounds = true
        rainEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.point
        rainEmitterLayer.beginTime = CACurrentMediaTime()
        rainEmitterLayer.timeOffset = 10.0
        rainEmitterCell.contents = UIImage(named: "rainFlake")!.cgImage
        rainEmitterCell.emissionRange = 1
        rainEmitterCell.lifetime = 5.0
        rainEmitterCell.birthRate = 300
        rainEmitterCell.scale = 0.15
        rainEmitterCell.scaleRange = 0.6
        rainEmitterCell.velocity = 100
        rainEmitterCell.velocityRange = 100
        rainEmitterCell.spin = -0.5
        rainEmitterCell.spinRange = 10.0
        rainEmitterCell.yAcceleration = 15.0
        rainEmitterCell.xAcceleration = -90.0
        blurryRainEmitterCell.contents = UIImage(named: "rainFlake_blurry")?.cgImage
        blurryRainEmitterCell.velocity = 100
        blurryRainEmitterCell.emissionRange = 1
        blurryRainEmitterCell.lifetime = 5.0
        blurryRainEmitterCell.birthRate = 300
        blurryRainEmitterCell.scale = 0.15
        blurryRainEmitterCell.scaleRange = 0.6
        blurryRainEmitterCell.velocityRange = 100
        blurryRainEmitterCell.spin = -0.5
        blurryRainEmitterCell.spinRange = 10.0
        blurryRainEmitterCell.yAcceleration = 15.0
        blurryRainEmitterCell.xAcceleration = -90.0
        rainEmitterLayer.emitterCells = [rainEmitterCell, blurryRainEmitterCell]
        snowEmitterLayer.removeFromSuperlayer()
        weatherView.layer.addSublayer(rainEmitterLayer)
    }
    func addSnow() {
        snowEmitterLayer.emitterPosition = CGPoint(x: weatherView.frame.width, y: 0)
        snowEmitterLayer.emitterSize = weatherView.bounds.size
        weatherView.clipsToBounds = true
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.point
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 10.0
        flakeEmitterCell.contents = UIImage(named: "snowflake_dot")!.cgImage
        flakeEmitterCell.emissionRange = 1
        flakeEmitterCell.lifetime = 20.0
        flakeEmitterCell.birthRate = 30
        flakeEmitterCell.scale = 0.15
        flakeEmitterCell.scaleRange = 0.6
        flakeEmitterCell.velocity = 30.0
        flakeEmitterCell.velocityRange = 20
        flakeEmitterCell.spin = -0.5
        flakeEmitterCell.spinRange = 1.0
        flakeEmitterCell.yAcceleration = 15.0
        flakeEmitterCell.xAcceleration = -90.0
        blurryFlakeEmitterCell.contents = UIImage(named: "snowflake_blurry_dot")?.cgImage
        blurryFlakeEmitterCell.velocity = 40
        blurryFlakeEmitterCell.emissionRange = 1
        blurryFlakeEmitterCell.lifetime = 20.0
        blurryFlakeEmitterCell.birthRate = 30
        blurryFlakeEmitterCell.scale = 0.15
        blurryFlakeEmitterCell.scaleRange = 0.6
        blurryFlakeEmitterCell.velocityRange = 20
        blurryFlakeEmitterCell.spin = -0.5
        blurryFlakeEmitterCell.spinRange = 1.0
        blurryFlakeEmitterCell.yAcceleration = 15.0
        blurryFlakeEmitterCell.xAcceleration = -90.0
        snowEmitterLayer.emitterCells = [flakeEmitterCell, blurryFlakeEmitterCell]
        rainEmitterLayer.removeFromSuperlayer()
        weatherView.layer.addSublayer(snowEmitterLayer)
    }
}

// MARK: -
// MARK: Configure Map
private extension StartViewController {
    func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        setActiveMode(true)
        locationManager.startUpdatingLocation()
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func configureDate() {
        let date = Date()
        dateSec = Int(date.timeIntervalSince1970)
    }
    
    func setActiveMode(_ value: Bool) {
               if value {
                   locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                   locationManager.distanceFilter = 10
               } else {
                   locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                   locationManager.distanceFilter = CLLocationDistanceMax
               }
           }
}

// MARK: -
// MARK: - Configure Weather
private extension StartViewController {
    func configureWeatherFromServer(completion: @escaping ((_ weather: WeatherModel?) -> Void)) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(myLocationLatitude ?? 0)&lon=\(myLocationLongitude ?? 0)&appid=\(APIConstants.APIKeyWeather)&units=metric") else {return}
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print(String(bytes: data, encoding: .utf8))
                if let weather = try? JSONDecoder().decode(WeatherModel.self, from: data) {
                    completion(weather)
                    return
                }
            }
            completion(nil)
        }
        task.resume()
    }
}

// MARK: -
// MARK: - Configure ManagerDelegate
extension StartViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Статус авторизации
        switch status {
        //Если он не определён (то есть ни одного запроса на авторизацию не было, то попросим базовую авторизацию)
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        //Если она ограничена или запрещена, то уведомим об отключении
        case .restricted, .denied:
            print("Отключаем локацию")
        //Если авторизация базовая, то попросим предоставить полную
        case .authorizedWhenInUse:
            print("Включаем базовые функции")
            manager.requestAlwaysAuthorization()
        //Хи-хи
        case .authorizedAlways:
            print("Теперь мы знаем, где Вы")
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.animate(to: camera)
            myLocationLatitude = Double(round(1000*location.coordinate.latitude)/1000)
            myLocationLongitude = Double(round(1000*location.coordinate.longitude)/1000)
            configureWeatherFromServer { [weak self] (weather) in
                if let weather = weather {
                    DispatchQueue.main.async {
                        self?.temp = weather.main?.temp as! Double
                        self?.main = weather.weather.last?.main as! String
                        self?.discription = weather.weather.last?.description as! String
                        if let sunset = weather.sys?.sunset,  let sunrise = weather.sys?.sunrise {
                        if self!.dateSec < sunset && self!.dateSec > sunrise {
                            self?.weatherImage.image = UIImage(named: self!.discription)
                            if weather.weather.last?.description == "overcast clouds" {
                                self?.weatherView.backgroundColor = self?.dayCloudsColor
                            } else {
                                self?.weatherView.backgroundColor = self?.daySunColor
                            }
                        } else {
                            self?.weatherView.backgroundColor = self?.nightColor
                            self?.weatherImage.image = UIImage(named: "moon")
                        }
                        self?.tempLabel.text = self?.discription
                        self?.weatherImage.image = UIImage(named: self!.discription)
                        self?.tempLabel.text = "\(Int(round(self?.temp ?? 0)))°"
                        if self?.discription == "light snow" || self?.discription == "heavy snow" || self?.discription == "snow"{
                            self?.addSnow()
                        } else if self?.discription == "light rain" || self?.discription == "moderate rain" || self?.discription == "rain"{
                             self?.addRain()
                          } else {
                            self?.rainEmitterLayer.removeFromSuperlayer()
                            self?.snowEmitterLayer.removeFromSuperlayer()
                            }
                        }
                        //self?.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let locationError = error as? CLError else {
            print(error)
            return
        }
        NSLog(locationError.localizedDescription)
    }
}

