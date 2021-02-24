//
//  RunViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/1/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class RunViewController: UIViewController {
    // - UI
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pageControlView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    // - Data
    var currentPage = 0
    var backgroundColor: UIColor = UIColor.white
    var textColor: UIColor = UIColor.black
    var darkTextColor: UIColor = UIColor.darkGray
    
    // - Timer
    var timer: Timer!
    var timerStatus: Bool!
    var seconds = 0
    var minutes = 0
    var hours = 0
    var allTimeInSeconds = 1
    var stopWatchString = "00:00:00"
    
    // - Colors
    var colorButtonsView = UIColor(red: 0.14902, green: 0.72941, blue: 0.75686, alpha: 1.0)
    var colorPageControlView = UIColor(red: 0.75294, green: 0.96078, blue: 0.98039, alpha: 1.0)
    
    // - SnapShot
    private var cache: SnapshotterCache!
    
    // - MapCollectionViewCellData
    var camera = GMSCameraPosition()
    var path = GMSMutablePath()
    var polyline = GMSPolyline()
    let locationManager = CLLocationManager()
    
    // - RunCollectionViewCellData
    var myLocations = [CLLocation]()
    var momentDistance = 0.0
    var generalDistance = 0.0
    var momentTime = 0.0
    var generalTime = 0.0
    var averageTempInSeconds = 0
    var averageTempString = "00:00:00"
    var currentTempString = "00:00:00"
    var momentSpeed = 0.0
    var averageSpeed = 0.0
    var calory = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    @IBAction func pauseButtonAction(_ sender: Any) {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        pageControlView.backgroundColor = .black
        buttonView.backgroundColor = .black
        pauseButton.isHidden = true
        continueButton.isHidden = false
        stopButton.isHidden = false
        stopUpdatingLocationManager()
        stopTimer()
        textColor = UIColor.white
        backgroundColor = UIColor.black
        collectionView.reloadData()
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        buttonView.backgroundColor = colorButtonsView
        pageControlView.backgroundColor = colorPageControlView
        view.backgroundColor = colorButtonsView
        collectionView.backgroundColor = .white
        pauseButton.isHidden = false
        continueButton.isHidden = true
        stopButton.isHidden = true
        startUpdatingLocationManager()
        startTimer()
        textColor = UIColor.black
        backgroundColor = UIColor.white
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        self.allert()
    }
    
}

// MARK: -
// MARK: Configure
extension RunViewController {
    func configure() {
        configureLocationManager()
        configureCollectionView()
        configurePageControl()
        configureButtons()
        scrollCollectionView()
        startTimer()
        configureCache()
    }
    
    func configureCache() {
        self.cache = SnapshotterCache()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocationManager() {
        locationManager.startUpdatingLocation()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - buttonView.frame.height - pageControlView.frame.height - 78)
    }
    
    func configurePageControl() {
        pageControl.numberOfPages = 2
        pageControl.currentPage = 1
    }
    
    func scrollCollectionView() {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
    
    func configureButtons() {
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        pauseButton.clipsToBounds = true
        continueButton.setImage(UIImage(named: "play"), for: .normal)
        continueButton.clipsToBounds = true
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.clipsToBounds = true
        continueButton.isHidden = true
        stopButton.isHidden = true
    }
    
    func configureTemp() {
        let doubleCurrentTempInSeconds = round(1 / momentSpeed)
        let doubleAverageTempInSeconds = round(1 / averageSpeed)
        guard !(doubleCurrentTempInSeconds.isNaN || doubleCurrentTempInSeconds.isInfinite) else {
            return
        }
        guard !(doubleAverageTempInSeconds.isNaN || doubleAverageTempInSeconds.isInfinite) else {
            return
        }
        // - configureCurrentTemp
        let currentHours = Int(doubleCurrentTempInSeconds / 3600)
        let currentMinutes = Int(doubleCurrentTempInSeconds.truncatingRemainder(dividingBy: 3600)/60)
        let currentSeconds = Int(doubleCurrentTempInSeconds.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        let currentSecondsString = currentSeconds > 9 ?"\(currentSeconds)" : "0\(currentSeconds)"
        let currentMinutesString = currentMinutes > 9 ?"\(currentMinutes)" : "0\(currentMinutes)"
        let currentHoursString = currentHours > 9 ? "\(currentHours)" : "0\(currentHours)"
        let currentTempInSeconds = Int(doubleCurrentTempInSeconds)
        if currentTempInSeconds < 3600 {
        currentTempString = "\(currentMinutesString):\(currentSecondsString)"
        }else  {
            currentTempString = "\(currentHoursString):\(currentMinutesString):\(currentSecondsString)"
        }
        // - configureAverageTemp
        let averageHours = Int(doubleAverageTempInSeconds / 3600)
        let averageMinutes = Int(doubleAverageTempInSeconds.truncatingRemainder(dividingBy: 3600)/60)
        let averageSeconds = Int(doubleAverageTempInSeconds.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        let averageSecondsString = averageSeconds > 9 ?"\(averageSeconds)" : "0\(averageSeconds)"
        let averageMinutesString = averageMinutes > 9 ?"\(averageMinutes)" : "0\(averageMinutes)"
        let averageHoursString = averageHours > 9 ? "\(averageHours)" : "0\(averageHours)"
        averageTempInSeconds = Int(doubleAverageTempInSeconds)
        if averageTempInSeconds < 3600 {
         averageTempString = "\(averageMinutesString):\(averageSecondsString)"
        } else {
            averageTempString = "\(averageHoursString):\(averageMinutesString):\(averageSecondsString)"
        }
        
    }
    func configureCalory() {
        calory = allTimeInSeconds / 4
    }

}

// MARK: -
// MARK: DataSource CollectionView
extension RunViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let runCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunCollectionViewCell", for: indexPath) as! RunCollectionViewCell
        let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as! MapCollectionViewCell
        runCell.runVC = self
        if indexPath.item == 0 && indexPath.section == 0 {
            mapCell.delegate = self
            mapCell.mapView.animate(to: camera)
            polyline.map = mapCell.mapView
            return mapCell
        } else {
            runCell.timeLabel.textColor = textColor
            runCell.timeLabel.backgroundColor = backgroundColor
            runCell.distanceLabel.textColor = textColor
            runCell.distanceLabel.backgroundColor = backgroundColor
            runCell.currentTempLabel.textColor = textColor
            runCell.currentTempLabel.backgroundColor = backgroundColor
            runCell.averageTempLabel.textColor = textColor
            runCell.averageTempLabel.backgroundColor = backgroundColor
            runCell.discriptionTimeLabel.textColor = darkTextColor
            runCell.discriptionTimeLabel.backgroundColor = backgroundColor
            runCell.discriptionDistanceLabel.textColor = darkTextColor
            runCell.discriptionDistanceLabel.backgroundColor = backgroundColor
            runCell.discriptionCurrentTempLabel.textColor = darkTextColor
            runCell.discriptionCurrentTempLabel.backgroundColor = backgroundColor
            runCell.discriptionAverageTempLabel.textColor = darkTextColor
            runCell.discriptionAverageTempLabel.backgroundColor = backgroundColor
            runCell.timeLabel.text = stopWatchString
            runCell.distanceLabel.text = "\(generalDistance)"
            runCell.currentTempLabel.text = currentTempString
            runCell.averageTempLabel.text = averageTempString
            return runCell
        }
    }
}

// MARK: -
// MARK: Delegate CollectionView
extension RunViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        currentPage = currentIndex
        pageControl.currentPage = currentPage
    }
    
}

// MARK: -
// MARK: Delegate CollectionViewCell
extension RunViewController: RunCollectionViewCellDelegate {
    func didTapNextButton () {
         let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK: -
// MARK: Timer
extension RunViewController {
    func configureTimer() {
        if timerStatus {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
        } else {
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timerStatus = true
        configureTimer()
    }
    
    func stopTimer() {
        timerStatus = false
        configureTimer()
    }
    
    @objc func timerUpdate() {
        allTimeInSeconds += 1
         seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        stopWatchString = "\(hoursString):\(minutesString):\(secondsString)"
        
        }
}

// MARK: -
// MARK: Allert
extension RunViewController {
    func allert () {
        let alertController = UIAlertController(title: "Завершение", message: "Вы уверены, что хотите завершить?", preferredStyle: .actionSheet)
        let yesAlertAction = UIAlertAction(title: "Да, завершить", style: .default) { (action) in
            let navigateVC = UIStoryboard(name: "Save", bundle: nil).instantiateInitialViewController() as! UINavigationController
            navigateVC.modalPresentationStyle = .overFullScreen
            let saveVC = navigateVC.viewControllers[0] as! SaveViewController
            self.configureDataForSaveVC()
            
        }
        alertController.addAction(yesAlertAction)
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
}

// MARK: -
// MARK: Configure Data For SaveViewController
extension RunViewController {
    func configureDataForSaveVC() {
        let navigateVC = UIStoryboard(name: "Save", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigateVC.modalPresentationStyle = .overFullScreen
        let saveVC = navigateVC.viewControllers[0] as! SaveViewController
        saveVC.distance = self.generalDistance
        saveVC.averageTemp = self.averageTempString
        saveVC.tempInSeconds = self.averageTempInSeconds
        saveVC.timeInSeconds = self.allTimeInSeconds
        saveVC.calory = self.calory
        saveVC.timeString = self.stopWatchString
        saveVC.routes = self.myLocations
        self.present(navigateVC, animated: true, completion: nil)
        }
}

// MARK: -
// MARK: LocationManagerDelegate
extension RunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Отключаем локацию")
        case .authorizedWhenInUse:
            print("Включаем базовые функции")
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            print("Теперь мы знаем, где Вы")
        @unknown default:
            print("упс")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
             camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            //mapView.animate(to: camera)
            path.add(location.coordinate)
            polyline = GMSPolyline(path: path)
            polyline.strokeColor = .red
            polyline.strokeWidth = 5
            myLocations.append(location)
            if myLocations.count > 1 {
                let difference = Calendar.current.dateComponents([.second], from: myLocations[myLocations.count - 2].timestamp, to: myLocations.last!.timestamp)
                let momentTime = Double(difference.second!)
                print(momentTime)
                let nowDistance = Double(myLocations.last!.distance(from: myLocations[myLocations.count - 2]))
                let momentDistance = nowDistance / 1000
                print(momentDistance)
                generalDistance += round(momentDistance * 100) / 100
                generalDistance = round(generalDistance * 100) / 100
                print(generalDistance)
                if momentTime == 0.0 {
                    momentSpeed = 0.01
                } else {
                momentSpeed = round((momentDistance / momentTime) * 1000) / 1000
                averageSpeed = round((generalDistance / Double(allTimeInSeconds)) * 1000) / 1000
               }
                guard !(momentSpeed.isNaN || momentSpeed.isInfinite) else {
                    return
                }
                guard !(averageSpeed.isNaN || averageSpeed.isInfinite) else {
                    return
                }
                self.configureTemp()
                self.configureCalory()
                print("runVC: дистанция - \(generalDistance), темп момент. - \(currentTempString), темп средний - \(averageTempString)")
            collectionView.reloadData()
        }
    }
}
}
