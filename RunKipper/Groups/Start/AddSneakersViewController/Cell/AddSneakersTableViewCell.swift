//
//  AddSneakersTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/10/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class AddSneakersTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton()
    }

}

// MARK: -
// MARK: TextField
extension AddSneakersTableViewCell {
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
        self.endEditing(true)
    }
}
