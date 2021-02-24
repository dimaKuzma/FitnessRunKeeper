//
//  PreviewTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/18/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    // - UI
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var rectangleView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
    }

}

// MARK: -
// MARK: Configure
extension PreviewCollectionViewCell {
    func configureTextField() {
        textField.delegate = self
    }
}

// MARK: -
// MARK: TextField Delegate
extension PreviewCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
