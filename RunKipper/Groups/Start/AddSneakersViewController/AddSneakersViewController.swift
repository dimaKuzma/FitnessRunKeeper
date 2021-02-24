//
//  AddSneakersViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/10/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import RealmSwift

class AddSneakersViewController: UIViewController {
    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    var data = ["Бренд", "Модель", "Название", "Исходный пробег", "Срок службы"]
    var discription = ["Пример: Asics", "Пример:Gel-Kayano", "Пример: Red Kayanos", "0 км", "400 кмм"]
    
    // - Delegate
    weak var sneakersVC: SneakersViewController!
    
    // - Realm
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let brandCell = tableView.visibleCells[0] as! AddSneakersTableViewCell
        let modelCell = tableView.visibleCells[1] as! AddSneakersTableViewCell
        let nameCell = tableView.visibleCells[2] as! AddSneakersTableViewCell
        let mileageCell = tableView.visibleCells[3] as! AddSneakersTableViewCell
        let termCell = tableView.visibleCells[4] as! AddSneakersTableViewCell
        let sneakersProfile = SneakersProfile()
        if brandCell.textField.text == "" {
            showAlert(message: "Введите \(brandCell.nameLabel.text ?? "")")
        } else if modelCell.textField.text == "" {
            showAlert(message: "Введите \(modelCell.nameLabel.text ?? "")")
        } else if nameCell.textField.text == "" {
            showAlert(message: "Введите \(nameCell.nameLabel.text ?? "")")
        } else if mileageCell.textField.text == "" {
            showAlert(message: "Введите \(mileageCell.nameLabel.text ?? "")")
        } else if termCell.textField.text == "" {
            showAlert(message: "Введите \(termCell.nameLabel.text ?? "")")
        }
        
        sneakersProfile.brand = brandCell.textField.text ?? ""
        sneakersProfile.model = modelCell.textField.text ?? ""
        sneakersProfile.name = nameCell.textField.text ?? ""
        sneakersProfile.mileage = Int(mileageCell.textField.text ?? "") ?? 0
        sneakersProfile.term = Int(termCell.textField.text ?? "") ?? 500
        try! realm.write {
            realm.add(sneakersProfile, update: .all)
        }
        sneakersVC.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    

}

// MARK: -
// MARK: Configure
extension AddSneakersViewController {
    func configure() {
        configureTableView()
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: -
// MARK: TableView DataSource
extension AddSneakersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSneakersTableViewCell", for: indexPath) as! AddSneakersTableViewCell
        cell.nameLabel.text = data[indexPath.row]
        cell.textField.placeholder = discription[indexPath.row]
        if indexPath.row == 3 || indexPath.row == 4 {
            cell.textField.keyboardType = .numberPad
        } else {
            cell.textField.keyboardType = .default
        }
        return cell
    }
    
    
}

// MARK: -
// MARK: TableView DataSource
extension AddSneakersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: -
// MARK: Alert
extension AddSneakersViewController {
        func showAlert(message:String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("Ok pressed")
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


