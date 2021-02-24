//
//  NotesViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/9/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    // - UI
    @IBOutlet weak var textView: UITextView!
    
    // - Delegate
    weak var saveVC: SaveViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

// MARK: -
// MARK: Configure
// MARK: Buttons | Data
extension NotesViewController {
    func configure() {
        configureTextView()
        configureTitle()
        configureButtons()
    }
    
    func configureTextView() {
        textView.becomeFirstResponder()
    }
    
    func configureTitle() {
        title = "Заметки"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configureButtons() {
        let rightButton = UIBarButtonItem.init(title: "Добавить", style: .done, target: self, action: #selector(self.handleTapSave(_:)))
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func handleTapSave(_ sender: UITapGestureRecognizer) {
        saveVC.data[0] = textView.text
        saveVC.note = textView.text 
        saveVC.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapBack(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}
