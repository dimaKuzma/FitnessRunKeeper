//
//  AddTimeViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 1/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import PanModal

class AddTimeViewController: UIViewController {
    // - UI
    @IBOutlet weak var pickerView: UIPickerView!
    
    // - PanModal
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    // - PickerView
    var hour: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    // - Delegate
    var addWorkoutVC: AddWorkoutViewController!
    
    // - Data
    var selectedHour = "0"
    var selectedMinute = "0"
    var selectedSecond = "0"
    var time = "0"
    var timeInMinutes = 0.0
    var timeInSeconds = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if pickerView.selectedRow(inComponent: 0) < 10 {
            selectedHour = "0" + "\(pickerView.selectedRow(inComponent: 0))"
        } else {
            selectedHour = "\(pickerView.selectedRow(inComponent: 0))"
        }
         if pickerView.selectedRow(inComponent: 1) < 10 {
                   selectedMinute = "0" + "\(pickerView.selectedRow(inComponent: 1))"
         } else {
            selectedMinute = "\(pickerView.selectedRow(inComponent: 1))"
        }
        if pickerView.selectedRow(inComponent: 2) < 10 {
                   selectedSecond = "0" + "\(pickerView.selectedRow(inComponent: 2))"
        } else {
            selectedSecond = "\(pickerView.selectedRow(inComponent: 2))"
        }
        if pickerView.selectedRow(inComponent: 0) == 0 {
        time = selectedMinute + ":" + selectedSecond
        } else {
            time = selectedHour + ":" + selectedMinute + ":" + selectedSecond
        }
        var minutesFromHours: Double = Double(pickerView.selectedRow(inComponent: 0) * 60)
        var minutesFromMinutes:Double = Double(pickerView.selectedRow(inComponent: 1))
        var minutesFromSeconds: Double = Double(pickerView.selectedRow(inComponent: 2)) / 60
        timeInMinutes = minutesFromHours + minutesFromMinutes + minutesFromSeconds
        var secondsFromHours: Int = Int(pickerView.selectedRow(inComponent: 0) * 3600)
        var secondsFromMinutes:Int = Int(pickerView.selectedRow(inComponent: 1) * 60)
        var secondsFromSeconds: Int = Int(pickerView.selectedRow(inComponent: 2))
        timeInSeconds = secondsFromHours + secondsFromMinutes + secondsFromSeconds
        self.addWorkoutVC.changeTime(time: time)
        self.addWorkoutVC.timeInMinutes = timeInMinutes
        self.addWorkoutVC.timeInSeconds = timeInSeconds
        self.addWorkoutVC.configureCalory()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: -
// MARK: Configure
extension AddTimeViewController {
    func configure() {
        configurePickerView()
    }
    
    func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

// MARK: -
// MARK: PanModal
extension AddTimeViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}

// MARK: -
// MARK: PickerView
extension AddTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 2:
            return 60
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) ч"
        case 1:
            return "\(row) мин"
        case 2:
            return "\(row) сек"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
    }
}
