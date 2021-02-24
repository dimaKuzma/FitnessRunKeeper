//
//  MoreTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 1/30/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // - VC
    weak var moreVC: MoreViewController!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.isHidden = true
    }

}

// MARK: -
// MARK: textField
extension MoreTableViewCell {
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
        if let pulse = textField.text {
            moreVC.discription[0] = pulse + " уд./мин"
            moreVC.pulse = Int(pulse) ?? 0
        }
        textField.isHidden = true
        self.endEditing(true)
        moreVC.tableView.reloadData()
        
    }
}
