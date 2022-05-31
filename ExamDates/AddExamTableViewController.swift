//
//  AddExamTableViewController.swift
//  ExamDates
//
//  Created by Muallim on 21.05.2022.
//

import UIKit

class AddExamTableViewController : UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var exam : ExamItem?
    let examManager = ExamManager()
    var remainTime : String?
    
    let source = ["5 Min", "10 Min", "15 Min", "30 Min", "45 Min", "1 Hour", "1 Hour 30 Min", "2 Hour"]
    
    let dateLabelCellIndexPath = IndexPath(row: 1, section: 1)
    let datePickerCellIndexPath = IndexPath(row: 2, section: 1)
    let remainTimePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var remainTimePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remainTimePicker.delegate = self
        remainTimePicker.dataSource = self
        
        var dateComponents = DateComponents()
        dateComponents.setValue(2, for: .minute)
        
        //datePicker'daki minimum tarihi belirler.
        datePicker.minimumDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        updateDateViews()
    }
    
    func numberOfComponents(in remainTimePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ remainTimePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return source[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.remainTime = source[row]
        updateDateViews()
    }
    
    
    //ekran açıldığında textField'ın seçilmesini sağlar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.becomeFirstResponder()
    }
    
    //remindMeSwitch durumuna göre dateLabelCell ve datePickerCell'i ölçeklendirmeyi sağlar.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dateLabelCellIndexPath:
            if remindMeSwitch.isOn {
                return 44
            } else {
                return 0
            }
        case datePickerCellIndexPath:
            if remindMeSwitch.isOn {
                return 216
            } else {
                return 0
            }
        case remainTimePickerCellIndexPath:
            if remindMeSwitch.isOn {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    //dateLabel'a seçilen tarih verilir.
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var date : Date?
        
        date = datePicker.date
        switch remainTime {
        case "5 Min":
            date?.addTimeInterval(5 * 60)
        case "10 Min":
            date?.addTimeInterval(10 * 60)
        case "15 Min":
            date?.addTimeInterval(15 * 60)
        case "30 Min":
            date?.addTimeInterval(30 * 60)
        case "45 Min":
            date?.addTimeInterval(45 * 60)
        case "1 Hour":
            date?.addTimeInterval(60 * 60)
        case "1 Hour 30 Min":
            date?.addTimeInterval(90 * 60)
        case "2 Hour":
            date?.addTimeInterval(120 * 60)
        default:
            date?.addTimeInterval(0)
        }
        
        
        dateLabel.text = dateFormatter.string(from: date!)
    }
    
    func updateCells() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @IBAction func remindMeSwitchValueChanged(_ sender: UISwitch) {
        updateCells()
    }
    
    //datePickerValue değiştiğinde updateDateViews methodunu çağırır.
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    //cancel Butonuna tıklandığında sayfayı dismiss eder.
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //done butonuna tıklandığında textField'tan text'i datePicker'dan date'i alıp yeni bir ExamItem öğesi oluşturur.
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        var date : Date?
        
        if remindMeSwitch.isOn {
            date = datePicker.date
            switch remainTime {
            case "5 Min":
                date?.addTimeInterval(5 * 60)
            case "10 Min":
                date?.addTimeInterval(10 * 60)
            case "15 Min":
                date?.addTimeInterval(15 * 60)
            case "30 Min":
                date?.addTimeInterval(30 * 60)
            case "45 Min":
                date?.addTimeInterval(45 * 60)
            case "1 Hour":
                date?.addTimeInterval(60 * 60)
            case "1 Hour 30 Min":
                date?.addTimeInterval(90 * 60)
            case "2 Hour":
                date?.addTimeInterval(120 * 60)
            default:
                date?.addTimeInterval(0)
            }
        }
        
        let newExam = ExamItem(title: titleTextField.text!, date: date)
        
        examManager.create(exam: newExam)
        performSegue(withIdentifier: "unwindToExams", sender: nil)
    }
}

//textField boş olmadığında done butonunu aktif hale getiren extension
extension AddExamTableViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if titleTextField.text != "" {
            addBarButton.isEnabled = true
        } else {
            addBarButton.isEnabled = false
        }
    }
}
