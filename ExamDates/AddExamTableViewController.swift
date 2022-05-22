//
//  AddExamTableViewController.swift
//  ExamDates
//
//  Created by Muallim on 21.05.2022.
//

import UIKit

class AddExamTableViewController : UITableViewController {
    
    var exam : ExamItem?
    let examManager = ExamManager()
    
    let dateLabelCellIndexPath = IndexPath(row: 1, section: 1)
    let datePickerCellIndexPath = IndexPath(row: 2, section: 1)
    var isDatePickerShow = false
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dateComponents = DateComponents()
        dateComponents.setValue(2, for: .minute)
        
        datePicker.minimumDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        updateDateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dateLabelCellIndexPath:
            if remindMeSwitch.isOn {
                return 44
            } else {
                return 0
            }
        case datePickerCellIndexPath:
            if isDatePickerShow && remindMeSwitch.isOn {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == datePickerCellIndexPath {
            isDatePickerShow.toggle()
            updateCells()
        }
    }
    
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    func updateCells() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    @IBAction func remindMeSwitchValueChanged(_ sender: UISwitch) {
        if !sender.isOn {
            isDatePickerShow = true
        }
        
        updateCells()
    }
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        var date : Date?
        
        if remindMeSwitch.isOn {
            date = datePicker.date
        }
        
        let newExam = ExamItem(title: titleTextField.text!, date: date)
        
        examManager.create(exam: newExam)
        performSegue(withIdentifier: "unwindToExams", sender: nil)
    }
}

extension AddExamTableViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if titleTextField.text != "" {
            addBarButton.isEnabled = true
        } else {
            addBarButton.isEnabled = false
        }
    }
}
