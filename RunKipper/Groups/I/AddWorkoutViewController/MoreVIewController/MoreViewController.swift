//
//  MoreViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 1/30/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var data = ["Средний пульс", "Обувь"]
    var discription = ["0 уд./мин", "Нет"]
    var sneakersProfile: SneakersProfile? = nil
    var pulse = 0
    
    // - VC
    weak var addWorkoutVC: AddWorkoutViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
}

// MARK: -
// MARK: Configure
extension MoreViewController {
    func configure() {
        configureTableView()
        configureAddButton()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureAddButton() {
        let rightButton = UIBarButtonItem.init(image: UIImage(named: "add"), style: .done, target: self, action: #selector(self.handleTapSave(_:)))
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func handleTapSave(_ sender: UITapGestureRecognizer) {
        addWorkoutVC.pulse = pulse
        addWorkoutVC.sneakersProfile = self.sneakersProfile ?? nil
        navigationController?.popViewController(animated: true)
    }
}

// MARK: -
// MARK: TableView DataSource
extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        if indexPath.row == 0 {
            cell.discriptionLabel.text = discription[indexPath.row]
            cell.textField.isHidden = true
        } else {
            cell.nameLabel.text = data[indexPath.row]
            cell.discriptionLabel.text = discription[indexPath.row]
            cell.discriptionLabel.textColor = .black
            cell.textField.isHidden = true
            if discription[indexPath.row] == "Нет" {
                cell.discriptionLabel.isHidden = true
            } else {
                cell.discriptionLabel.isHidden = false
            }
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
}

// MARK: -
// MARK: TableView Delegate
extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! MoreTableViewCell
            cell.moreVC = self
            cell.addButton()
            cell.textField.isHidden = false
            cell.textField.becomeFirstResponder()
        } else {
            let sneakersVC = UIStoryboard(name: "Sneakers", bundle: nil).instantiateInitialViewController() as! SneakersViewController
            sneakersVC.moreVC = self
            sneakersVC.checkmark = discription[indexPath.row]
            navigationController?.pushViewController(sneakersVC, animated: true)
        }
    }
}

