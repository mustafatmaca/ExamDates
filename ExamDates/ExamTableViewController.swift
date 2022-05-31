//
//  ExamTableViewController.swift
//  ExamDates
//
//  Created by Muallim on 21.05.2022.
//

import UIKit

class ExamTableViewController : UITableViewController {
    
    var examManager = ExamManager()
    
    //numberOfRowsInSwction methodu: tableView'de kaç tane row olucağını belirler.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examManager.getAllExams().count
    }
    
    //cellForRowAt methodu: tableView'deki cell içeriğini belirler.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell") as? ExamTableViewCell else {
            return UITableViewCell()
        }
        
        let exam = examManager.getAllExams()[indexPath.row]
        cell.prepare(with: exam)
        
        return cell
    }
    
    //leadingSwipe methodu: cell'deki sınavın tamamlanıp tamamlanmadığını soldan kaydırarak belirtmeyi sağlar.
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedExam = examManager.getAllExams()[indexPath.row]
        
        let completeAction = UIContextualAction(style: .normal, title: nil, handler: {(_, _, completion) in
            completion(true)
            
            self.examManager.setComplete(exam: selectedExam)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        })
        
        completeAction.image = selectedExam.isCompleted ? UIImage(systemName: "minus.circle.fill") : UIImage(systemName: "checkmark.circle.fill")
        completeAction.backgroundColor = selectedExam.isCompleted ? .lightGray : .orange
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    //trailingSwipe methodu: cell'deki sınavı sağdan kaydırarak silmeye yarar.
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedExam = examManager.getAllExams()[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (_, _, deleted) in
            deleted(true)
            self.examManager.delete(exam: selectedExam)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @IBAction func unwindFromAddExam(_ segue: UIStoryboardSegue) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
