//
//  SummaryViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/12/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var newsProfile = NewsProfile()
    
    // - Delegate
    weak var newsVC: NewsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: -
// MARK: Configure
extension SummaryViewController {
    func configure() {
        configureTableView()
        configureTitle()
    }
    
    func configureTitle() {
        title = "Сводка"
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: -
// MARK: DataSource TableView
extension SummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return "Подробнее"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameCell = tableView.dequeueReusableCell(withIdentifier: "SummaryNameTableViewCell") as! SummaryNameTableViewCell
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "SummaryDetailTableViewCell") as! SummaryDetailTableViewCell
        if indexPath.section == 0 && indexPath.row == 0 {
            nameCell.configureCache()
            nameCell.configureAvatar()
            nameCell.configureLabels(newsProfile: newsProfile)
            if newsProfile.route.count == 0 {
                nameCell.routeImage.image = UIImage(named: "nil")
            } else {
                nameCell.configureRouteImage(newsProfile: newsProfile)
                
            }
            return nameCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            detailCell.dataLabel.isHidden = true
            detailCell.noteLabel.isHidden = false
            detailCell.nameLabelCenterConstraint.constant = 0
            if newsProfile.note == "" {
                detailCell.noteLabel.text = "К этой тренировке нет заметок"
            } else {
                detailCell.noteLabel.text = newsProfile.note
            }
            return detailCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            detailCell.nameLabelCenterConstraint.constant = 10
            detailCell.noteLabel.isHidden = true
            detailCell.dataLabel.isHidden = false
            detailCell.nameLabel.text = "Пульс"
            if newsProfile.pulse == 0 {
                detailCell.dataLabel.text = "Нет"
            } else {
                detailCell.dataLabel.text = "\(newsProfile.pulse) уд/мин"
            }
            return detailCell
        } else {
            return detailCell
        }
    }
}

// MARK: -
// MARK: Delegate TableView
extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 350
        } else {
            return 60
        }
    }
}

