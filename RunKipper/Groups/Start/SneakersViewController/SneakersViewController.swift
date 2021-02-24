//
//  SneakersViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/10/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class SneakersViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Delegate
    weak var saveVC: SaveViewController!
    weak var moreVC: MoreViewController!
    
    // - Realm
    let realm = try! Realm()
    var sneakersProfile = [SneakersProfile]()
    
    // - Data
    var checkmark = "Нет"

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configure()
    }
    

}

// MARK: -
// MARK: Configure
extension SneakersViewController {
    func configure() {
        configureRealm()
        configureTitleAndButton()
        configureTableView()
    }
    
    func configureRealm() {
        sneakersProfile = Array(realm.objects(SneakersProfile.self))
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureTitleAndButton() {
        title = "Обувь"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let rightButton = UIBarButtonItem.init(image: UIImage(named: "add"), style: .done, target: self, action: #selector(self.handleTapAdd(_:)))
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func handleTapAdd(_ sender: UITapGestureRecognizer) {
        let addSneakersVC = UIStoryboard(name: "AddSneakers", bundle: nil).instantiateInitialViewController() as! AddSneakersViewController
        addSneakersVC.sneakersVC = self
        navigationController?.pushViewController(addSneakersVC, animated: true)
    }
}

// MARK: -
// MARK: TableView DataSource
extension SneakersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sneakersProfile.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SneakersTableViewCell", for: indexPath) as! SneakersTableViewCell
        if sneakersProfile.count == 0 {
            cell.nameLabel.text = "Нет"
            cell.nameLabel.font = UIFont(name: "System", size: 23.0)
            cell.mileageLabel.isHidden = true
            cell.termLabel.isHidden = true
            cell.kmLabel.isHidden = true
            cell.slashLabel.isHidden = true
            cell.nameLabelCenterConstraint.constant = 10
            if cell.nameLabel.text == checkmark {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            if indexPath.row < sneakersProfile.count {
                cell.mileageLabel.isHidden = false
                cell.termLabel.isHidden = false
                cell.kmLabel.isHidden = false
                cell.slashLabel.isHidden = false
                cell.nameLabelCenterConstraint.constant = 0
                cell.nameLabel.text = sneakersProfile[indexPath.row].name
                cell.nameLabel.font = UIFont(name: "System", size: 17.0)
                cell.mileageLabel.text = "\(sneakersProfile[indexPath.row].mileage)"
                cell.termLabel.text = "\(sneakersProfile[indexPath.row].term)"
                if cell.nameLabel.text == checkmark {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                cell.nameLabel.text = "Нет"
                cell.nameLabel.font = UIFont(name: "System", size: 23.0)
                cell.mileageLabel.isHidden = true
                cell.termLabel.isHidden = true
                cell.kmLabel.isHidden = true
                cell.slashLabel.isHidden = true
                cell.nameLabelCenterConstraint.constant = 10
                if cell.nameLabel.text == checkmark {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            return cell
        }
    }
}

// MARK: -
// MARK: TableView DataSource
extension SneakersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SneakersTableViewCell
        if indexPath.row < sneakersProfile.count {
            cell.accessoryType = .checkmark
            if navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] == saveVC {
                self.saveVC.data[2] = cell.nameLabel.text ?? "Нет"
                self.saveVC.sneakersProfile = sneakersProfile[indexPath.row]
                self.saveVC.tableView.reloadData()
            } else if navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2]  == moreVC {
                self.moreVC.discription[1] = cell.nameLabel.text ?? "Нет"
                self.moreVC.sneakersProfile = sneakersProfile[indexPath.row]
                self.moreVC.tableView.reloadData()
            }
        } else {
            cell.accessoryType = .checkmark
            if navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2]  == saveVC {
                saveVC.data[2] = "Нет"
                saveVC.sneakersProfile = nil
                saveVC.tableView.reloadData()
            } else if navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2]  == moreVC{
                moreVC.discription[1] = "Нет"
                moreVC.sneakersProfile = nil
                moreVC.tableView.reloadData()
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

