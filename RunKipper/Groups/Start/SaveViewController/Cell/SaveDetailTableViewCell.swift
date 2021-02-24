//
//  SaveDetailTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/8/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class SaveDetailTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var discriptionImage: UIImageView!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // - Constraint
    @IBOutlet weak var discriptionLabelCenterConstraint: NSLayoutConstraint!
    
    // Delegate
    weak var saveVC: SaveViewController!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: -
// MARK: TextField
extension SaveDetailTableViewCell {
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
        textField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(_ sender: UIBarButtonItem){
        //discriptionLabel.isHidden = false
        if textField.text == "" {
            saveVC.pulse = 0
             saveVC.data[1] = "Добавить"
        } else {
            if let count = textField.text {
                saveVC.pulse = Int(count) ?? 0
                saveVC.data[1] = count + " уд/мин"
            }
        textField.isHidden = true
        self.endEditing(true)
        saveVC.tableViewTopConstraint.constant = 5
        saveVC.tableView.reloadData()
        }
    }
}
