//
//  AddWorkoutViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 1/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class AddWorkoutViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var currentDate = ""
    var shortDate = ""
    var data = ["Время", "Расстояние", "Калории", "Тип тренировки", "Дата и время", "Подробнее"]
    var discription = ["--:--", "-.--", "---", "Бег", "27.01.2021, 12:48", ""]
    var timeInMinutes = 0.0
    var distance = 0.0
    var tempString = ""
    var tempInSeconds = 0
    var timeInSeconds = 0
    var sneakersProfile: SneakersProfile? = nil
    var pulse = 0
    var ccal = 0
    
    // - Realm
    let realm = try! Realm()
    
    // - VC
    weak var workoutVC: WorkoutViewController!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // - Dictionary
    var week: [String: String] = ["Monday":"Понедельник", "Tuesday":"Вторник", "Wednesday":"Среда", "Thursday":"Четверг", "Friday":"Пятница", "Saturday":"Суббота", "Sunday":"Воскресение"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        let secondIndexPath = IndexPath(item: 1, section: 0)
        let firstCell = tableView.cellForRow(at: firstIndexPath) as! AddWorkoutTableViewCell
        let secondCell = tableView.cellForRow(at: secondIndexPath) as! AddWorkoutTableViewCell
        if firstCell.discriptionLabel.text == "--:--" {
            showAlert(message: "Введите время")
            return
        }
        if secondCell.discriptionLabel.text == "-.--" {
            showAlert(message: "Введите дистанцию")
            return
        }
        configureTemp()
        configureCalory()
        let news = NewsProfile()
        news.distance = distance
        news.time = discription[0]
        news.temp = tempString
        news.fullDate = currentDate
        news.shortDate = shortDate
        news.pulse = pulse
        news.route = List<Location>()
        news.timeInSeconds = timeInSeconds
        news.tempInSeconds = tempInSeconds
        news.calory = ccal
        let newsProfile = Array(realm.objects(NewsProfile.self))
        var theBiggestDistance = 0.0
        for new in newsProfile {
            if new.distance > theBiggestDistance {
                theBiggestDistance = new.distance
            }
        }
        if news.distance > theBiggestDistance {
            appDelegate?.recordNotification(notificationType: "Новый рекорд", distance: Int(news.distance))
        }else {
            //
        }
        try! realm.write {
            realm.add(news, update: .all)
        }
        if let sneakersProfile = sneakersProfile {
            try! realm.write{
            sneakersProfile.mileage += Int(distance)
            }
            if sneakersProfile.mileage > sneakersProfile.term {
                appDelegate?.sneakersNotification(notificationType: "Обувь износилась", distance: sneakersProfile.term, name: sneakersProfile.brand)
            }
            try! realm.write {
                realm.add(sneakersProfile, update: .all)
            }
        }
        workoutVC.configureRealm()
        workoutVC.tableView.reloadData()
        workoutVC.configureCountAndKilo()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: -
// MARK: Configure
extension AddWorkoutViewController {
    func configure() {
        configureTableView()
        configureDate()
        configureTitle()
        configureAddButton()
    }
    
    func configureTitle() {
        title = "Бег"
    }
    func configureAddButton() {
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func configureDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        currentDate = dateFormatter.string(from: date)
        discription[4] = currentDate
        dateFormatter.dateFormat = "EEEE"
        if let rusDate = week[String(dateFormatter.string(from: date))] {
            shortDate = rusDate
        } else {
            return
        }
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func configureTemp() {
        tempInSeconds = Int(timeInSeconds / Int(distance))
        let hoursTemp = tempInSeconds / 3600
        let minutesTemp = (tempInSeconds % 3600) / 60
        let secondsTemp = (tempInSeconds % 3600) % 60
        let hoursTempString = hoursTemp > 9 ?"\(hoursTemp)" : "0\(hoursTemp)"
        let minutesTempString = minutesTemp > 9 ?"\(minutesTemp)" : "0\(minutesTemp)"
        let secondsTempString = secondsTemp > 9 ?"\(secondsTemp)" : "0\(secondsTemp)"
        if tempInSeconds < 3600 {
            tempString = minutesTempString + ":" + secondsTempString
        }else {
            tempString = hoursTempString + ":" + minutesTempString + ":" + secondsTempString
        }
    }
    
    func configureCalory() {
        if discription[0] == "--:--" && discription[1] == "-.--" {
            discription[2] = "---"
        } else if discription[0] == "--:--" && discription[1] != "-.--" {
            ccal = Int(70 * distance)
            discription[2] = "\(ccal) ккал"
            
        } else if discription[0] != "--:--" && discription[1] == "-.--" {
            ccal = Int(8 * timeInMinutes)
            discription[2] = "\(ccal) ккал"
            
        } else if discription[0] != "--:--" && discription[1] != "-.--" {
            let speed = (Int(distance) * 1000)/(Int(timeInMinutes) * 60)
            ccal = Int((2.275 + 1.885 * (Double(speed * speed) / 1.7)) * 9.5)
            discription[2] = "\(ccal) ккал"
        }
        tableView.reloadData()
    }
}

// MARK: -
// MARK: DelegateFunc
extension AddWorkoutViewController {
    func changeTime(time: String) {
        discription[0] = time
        tableView.reloadData()
    }
}

// MARK: -
// MARK: DataSource tableView
extension AddWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddWorkoutTableViewCell", for: indexPath) as! AddWorkoutTableViewCell
        cell.distanceTextField.isHidden = true
        cell.nameLabel.text = data[indexPath.row]
        cell.discriptionLabel.text = discription[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.row == 4 {
            cell.discriptionLabel.font = UIFont(descriptor: .init(name: "System Semibold", size: 24.0), size: 24.0)
        } else if indexPath.row == 5 {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    
}

// MARK: -
// MARK: Delegate tableView
extension AddWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let addTimeVC = UIStoryboard(name: "AddTime", bundle: nil).instantiateInitialViewController() as! AddTimeViewController
            addTimeVC.addWorkoutVC = self
            self.presentPanModal(addTimeVC)
        } else if indexPath.row == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! AddWorkoutTableViewCell
            cell.addWorkoutVC = self
            cell.selectionStyle = .none
            cell.distanceTextField.isHidden = false
            cell.addButton()
            cell.distanceTextField.becomeFirstResponder()
            cell.nameLabel.text = data[indexPath.row]
            
        } else if indexPath.row == 2 {
            //
        } else if indexPath.row == 3 {
            //
        } else if indexPath.row == 4 {
            //
        } else if indexPath.row == 5 {
            let moreVC = UIStoryboard(name: "More", bundle: nil).instantiateInitialViewController() as! MoreViewController
            moreVC.addWorkoutVC = self
            navigationController?.pushViewController(moreVC, animated: true)
        }
    }
}

// MARK: -
// MARK: Allert
extension AddWorkoutViewController {
    func showAlert(message:String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("Ok pressed")
        }
        alertController.addAction(okAction)
    }
}
