//
//  SaveViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/8/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class SaveViewController: UIViewController {
    // - UI
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var caloryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var imageForMap: UIImage!
    var distance = 0.0
    var averageTemp = ""
    var tempInSeconds = 0
    var timeInSeconds = 0
    var timeString = ""
    var calory = 0
    var routes = [CLLocation]()
    var fullDate = ""
    var shortDate = ""
    var pulse = 0
    var note = ""
    var data = ["К этой тренировке нет заметок", "Добавить", "Нет"]
    
    // - Cache & appDelegate
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var cache: SnapshotterCache!
    
    // - Realm
    let realm = try! Realm()
    var sneakersProfile: SneakersProfile? = nil
    
    // - Dictionary
    var week: [String: String] = ["Monday":"Понедельник", "Tuesday":"Вторник", "Wednesday":"Среда", "Thursday":"Четверг", "Friday":"Пятница", "Saturday":"Суббота", "Sunday":"Воскресение"]
    
    // - Constraint
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let newProfile = NewsProfile()
        
        newProfile.distance = distance
        newProfile.time = timeString
        newProfile.temp = averageTemp
        newProfile.fullDate = fullDate
        newProfile.shortDate = shortDate
        newProfile.pulse = pulse
        newProfile.note = note
        newProfile.tempInSeconds = tempInSeconds
        newProfile.timeInSeconds = timeInSeconds
        for rout in routes {
            let location = Location(rout.coordinate.latitude,  rout.coordinate.longitude)
            newProfile.route.append(location)
        }
        newProfile.calory = calory
        let newsProfile = Array(realm.objects(NewsProfile.self))
        var theBiggestDistance = 0.0
        for new in newsProfile {
            if new.distance > theBiggestDistance {
                theBiggestDistance = new.distance
            }
        }
        if newProfile.distance > theBiggestDistance {
            appDelegate?.recordNotification(notificationType: "Новый рекорд", distance: Int(newProfile.distance))
        }else {
            print("Не новый рекорд")
        }
        try! realm.write {
            realm.add(newProfile)
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
        let tabBar = TabBarController()
        tabBar.selectedIndex = 2
        tabBar.modalPresentationStyle = .overFullScreen
        self.present(tabBar, animated: true, completion: nil)
        
    }
    

}

// MARK: -
// MARK: Configure
extension SaveViewController {
    func configure() {
        configureTime()
        configureLabels()
        configureCache()
        configureTitle()
        configureTableView()
        configureMapImage()
        configureDeleteButton()
        configureDate()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func configureCache() {
        self.cache = SnapshotterCache()
    }
    
    func configureTitle() {
       title = "Проверить и сохранить"
       let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
       navigationController?.navigationBar.titleTextAttributes = textAttributes
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func configureMapImage() {
        cache.getMapShaphsotAtWorkout(routes: routes) { (snapshot) in
            self.mapImage.image = snapshot
        }
    }
    
    func configureLabels() {
        self.caloryLabel.text = "\(calory)"
        self.tempLabel.text = averageTemp
        self.distanceLabel.text = "\(distance)"
        self.timeLabel.text = timeString
    }
    
    func configureTime() {
        if timeInSeconds < 3600 {
            let minutes = timeInSeconds / 60
            let seconds = timeInSeconds % 60
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            timeString = minutesString + ":" + secondsString
        } else {
            let hours = timeInSeconds / 3600
            let minutes = (timeInSeconds % 3600) / 60
            let seconds = (timeInSeconds % 3600) % 60
            let hoursString = hours > 9 ?"\(hours)" : "0\(hours)"
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            timeString = hoursString + ":" + minutesString + ":" + secondsString
        }
    }
    
    func configureDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        fullDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEEE"
        if let rusDate = week[String(dateFormatter.string(from: date))] {
            shortDate = rusDate
        } else {
            return
        }
    }
    
    func showRealm() {
        let newsProfile = Array(realm.objects(NewsProfile.self))
    }
    
    func configureDeleteButton() {
        let rightButton = UIBarButtonItem.init(image: UIImage(named: "delete"), style: .done, target: self, action: #selector(self.handleTap(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        showAlert()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Не сохранять тренировку?", message: "Ты уверен(а), что не хочешь сохранять тренировку?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { (action) in
            let tabBar = TabBarController()
            tabBar.selectedIndex = 2
            tabBar.modalPresentationStyle = .overFullScreen
            self.present(tabBar, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

// MARK: -
// MARK: DataSource TableView
extension SaveViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
           return 1
       } else {
           return 3
       }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Основное"
        } else {
            return "Подробнее"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameCell = tableView.dequeueReusableCell(withIdentifier: "SaveNameTableViewCell") as! SaveNameTableViewCell
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "SaveDetailTableViewCell") as! SaveDetailTableViewCell
        if indexPath.section == 0 && indexPath.row == 0 {
            nameCell.nameDiscriptionLabel.text = shortDate
            return nameCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            detailCell.dataLabel.isHidden = true
            detailCell.noteLabel.isHidden = false
            detailCell.textField.isHidden = true
            detailCell.discriptionLabel.text = "Как прошла тренировка?"
            detailCell.discriptionLabelCenterConstraint.constant = 0
            detailCell.noteLabel.text = data[indexPath.row]
            detailCell.accessoryType = .none
            return detailCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            detailCell.discriptionLabelCenterConstraint.constant = 10
            detailCell.noteLabel.isHidden = true
            detailCell.dataLabel.isHidden = false
            detailCell.textField.isHidden = true
            detailCell.discriptionLabel.text = "Средний пульс"
            detailCell.discriptionImage.image = UIImage(named:"pulse")
            detailCell.dataLabel.text = data[indexPath.row]
            if data[indexPath.row] == "Добавить" {
                detailCell.dataLabel.textColor = .black
            } else {
                detailCell.dataLabel.textColor = UIColor(red: 1, green: 151/255, blue: 0, alpha: 1)
            }
            detailCell.accessoryType = .none
            return detailCell
        } else {
            detailCell.discriptionLabelCenterConstraint.constant = 10
            detailCell.noteLabel.isHidden = true
            if data[indexPath.row] == "Нет" {
                detailCell.dataLabel.isHidden = true
            } else {
                detailCell.dataLabel.isHidden = false
            }
            detailCell.textField.isHidden = true
            detailCell.discriptionImage.image = UIImage(named: "average pace")
            detailCell.discriptionLabel.text = "Обувь"
            detailCell.dataLabel.text = data[indexPath.row]
            detailCell.accessoryType = .disclosureIndicator
            return detailCell
        }
    }
}

// MARK: -
// MARK: Delegate TableView
extension SaveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SaveDetailTableViewCell
        if indexPath.section == 0 && indexPath.row == 0 {
            //
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let notesVC = UIStoryboard(name: "Notes", bundle: nil).instantiateInitialViewController() as! NotesViewController
            notesVC.saveVC = self
            navigationController?.pushViewController(notesVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.saveVC = self
            cell.textField.isHidden = false
            cell.addButton()
            tableViewTopConstraint.constant = -260
            cell.textField.becomeFirstResponder()
        } else {
            let sneakersVC = UIStoryboard(name: "Sneakers", bundle: nil).instantiateInitialViewController() as! SneakersViewController
            sneakersVC.saveVC = self
            sneakersVC.checkmark = data[indexPath.row]
            navigationController?.pushViewController(sneakersVC, animated: true)
            
        }
    }
}
