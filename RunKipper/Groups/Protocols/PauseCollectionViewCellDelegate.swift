//
//  PauseCollectionViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/2/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

protocol PauseCollectionViewCellDelegate: class {
    func didTapPauseButton ()
    func didTapContinueButton()
}
