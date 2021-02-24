//
//  WorkoutViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 1/22/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var sections = ["Среда, 19.01.2021", "Вторник, 18.01.2021"]
    var newsProfile = [NewsProfile]()
    
    // - Realm
    let realm = try! Realm()
    
    // - VC
    weak var iVC:IViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: -
// MARK: Configure
extension WorkoutViewController {
    func configure() {
        configureRealm()
        configureTableView()
        configureTitle()
        configureAddButton()
    }
    
    func configureCountAndKilo() {
        iVC.configureCountOfWorkouts()
        iVC.collectionView.reloadData()
    }
    
    func configureRealm() {
        newsProfile = Array(realm.objects(NewsProfile.self))
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    func configureTitle() {
        title = "Тренировки"
    }
    
    func configureAddButton() {
        let rightButton = UIBarButtonItem.init(image: UIImage(named: "add"), style: .done, target: self, action: #selector(self.handleTap(_:)))
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let addWorkoutVC = UIStoryboard(name: "AddWorkout", bundle: nil).instantiateInitialViewController() as! AddWorkoutViewController
        addWorkoutVC.workoutVC = self
        addWorkoutVC.modalPresentationStyle = .overFullScreen
        navigationController?.popoverPresentationController?.sourceView = self.view
        navigationController?.pushViewController(addWorkoutVC, animated: true)
    }
}

// MARK: -
// MARK: DataSource tableVIew
extension WorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsProfile.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return newsProfile[section].fullDate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as! WorkoutTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.distanceLabel.text = "\(Int(newsProfile[indexPath.section].distance))"
        cell.timeLabel.text = newsProfile[indexPath.section].time
        return cell
    }
    
    
}

// MARK: -
// MARK: Delegate tableView
extension WorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
