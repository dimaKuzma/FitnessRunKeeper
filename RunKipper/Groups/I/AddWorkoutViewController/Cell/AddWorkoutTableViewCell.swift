//
//  AddWorkoutTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 1/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class AddWorkoutTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    
    // - Delegate
    weak var addWorkoutVC: AddWorkoutViewController!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

// MARK: -
// MARK: TextField
extension AddWorkoutTableViewCell {
    func addButton() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    doneToolbar.barStyle = UIBarStyle.default
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction(_:)))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        distanceTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem){
        if let distance = distanceTextField.text {
            self.addWorkoutVC.discription[1] = distance + ",00 км"
            self.addWorkoutVC.distance = Double(distanceTextField.text!)!
        }
        self.endEditing(true)
        if distanceTextField.text == nil {
            addWorkoutVC.discription[1] = "-.--"
        } else if distanceTextField.text == "" {
            addWorkoutVC.discription[1] = "-.--"
        }
        self.endEditing(true)
        distanceTextField.isHidden = true
        addWorkoutVC.configureCalory()
        addWorkoutVC.tableView.reloadData()
    }
}
