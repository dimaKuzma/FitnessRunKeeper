//
//  addAvatarViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 1/9/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class AchievementsViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var maxTime = 0
    var dateMaxTime = ""
    var maxCalory = 0
    var dateMaxCalory = ""
    var maxTemp = 0
    var dateMaxTemp = ""
    var run = ["макс. расход калорий", "Макс. средний темп", "Макс. время"]
    var dataRun: [String] = ["0", "00:00 мин/км", "00:00"]
    var dateTheLongestWorkout = "нет"
    var theLongestWorkout = 0.0
    var date5kWorkout = "нет"
    var date10kWorkout = "нет"
    var date21kWorkout = "нет"
    var date42kWorkout = "нет"
    var continuening = "continueningNone"
    var fiveK = "5kNone"
    var tenK = "10kNone"
    var halfMarathon = "21kNone"
    var marathon = "42kNone"
    
    // - Realm
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: -
// MARK: Configure
extension AchievementsViewController {
    func configure() {
        configureTitle()
        configureAchievements()
        configureMaxAchievements()
        configureTableView()
    }
    
    func configureTime(time: Int) -> String {
        if time < 3600 {
            let minutes = time / 60
            let seconds = time % 60
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            return minutesString + ":" + secondsString
        } else {
            let hours = time / 3600
            let minutes = (time % 3600) / 60
            let seconds = (time % 3600) % 60
            let hoursString = hours > 9 ?"\(hours)" : "0\(hours)"
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            return hoursString + ":" + minutesString + ":" + secondsString
        }
    }
    
    func configureAchievements() {
        let newsProfile = Array(realm.objects(NewsProfile.self))
        if newsProfile.count != 0 {
            for new in newsProfile {
                if new.distance > theLongestWorkout {
                    continuening = "continuening"
                    theLongestWorkout = new.distance
                    dateTheLongestWorkout = new.fullDate
                }
                if new.distance >= 42.0 {
                    marathon = "42k"
                    date42kWorkout = new.fullDate
                } else if new.distance >= 21.0 {
                    date21kWorkout = new.fullDate
                    halfMarathon = "21k"
                } else if new.distance >= 10.0 {
                    tenK = "10k"
                    date10kWorkout = new.fullDate
                } else if new.distance >= 5.0 {
                    fiveK = "5k"
                    date5kWorkout = new.fullDate
                }
            }
            dataRun[0] = "\(maxCalory)"
            dataRun[1] = configureTime(time: maxTemp) + "мин/км"
            dataRun[2] = configureTime(time: maxTime)
        }
    }
    
    func configureMaxAchievements() {
        let newsProfile = Array(realm.objects(NewsProfile.self))
        if newsProfile.count != 0 {
            for new in newsProfile {
                if new.calory > maxCalory {
                    maxCalory = new.calory
                    dateMaxCalory = new.fullDate
                }
                if new.tempInSeconds > maxTemp {
                    maxTemp = new.tempInSeconds
                    dateMaxTemp = new.fullDate
                }
                if new.timeInSeconds > maxTime {
                    maxTime = new.timeInSeconds
                    dateMaxTime = new.fullDate
                }
            }
            
        }
    }
    
    func configureTitle() {
        title =  "Достижения"
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: -
// MARK: DataSource tableView
extension AchievementsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        view.backgroundColor = UIColor(displayP3Red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        var image = UIImage()
        if section == 0 {
            image = UIImage(named: "medal")!
        } else {
            image = UIImage(named: "count")!
        }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 5, width: 35, height: 35)
        view.addSubview(imageView)
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 15, width: 200, height: 20)
        if section == 0 {
            label.text = "Личные рекорды в беге"
        } else {
            label.text = "Бег"
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstCell = tableView.dequeueReusableCell(withIdentifier: "AchievementsTableViewCell") as! AchievementsTableViewCell
        let secondCell = tableView.dequeueReusableCell(withIdentifier: "RunTableViewCell") as! RunTableViewCell
        firstCell.selectionStyle = .none
        secondCell.selectionStyle = .none
        if indexPath.section == 0 {
            firstCell.continueningImage.image = UIImage(named: self.continuening)
            firstCell.continueningLabel.text = dateTheLongestWorkout
            firstCell.distanceLabel.text = "\(theLongestWorkout) км"
            firstCell.fiveKImage.image = UIImage(named: self.fiveK)
            firstCell.fiveKLabel.text = self.date5kWorkout
            firstCell.tenKImage.image = UIImage(named:self.tenK)
            firstCell.tenKLabel.text = self.date10kWorkout
            firstCell.halfMarathonImage.image = UIImage(named:self.halfMarathon)
            firstCell.halfMarathonLabel.text = self.date21kWorkout
            firstCell.marathonImage.image = UIImage(named:self.marathon)
            firstCell.marathonLabel.text = self.date42kWorkout
            return firstCell
        } else {
            secondCell.nameLabel.text = run[indexPath.row]
            secondCell.countLabel.text = dataRun[indexPath.row]
            if indexPath.section == 1 && indexPath.row == 0 {
                secondCell.dateLabel.text  = dateMaxCalory
            } else if indexPath.section == 1 && indexPath.row == 1 {
                secondCell.dateLabel.text = dateMaxTemp
            } else if indexPath.section == 1 && indexPath.row == 2 {
                secondCell.dateLabel.text = dateMaxTime
            }
            return secondCell
        }
    }
}

// MARK: -
// MARK: Delegate tableView
extension AchievementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 550
        } else {
            return 60
        }
    }
}
