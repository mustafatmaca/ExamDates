//
//  ExamTableViewCell.swift
//  ExamDates
//
//  Created by Muallim on 22.05.2022.
//

import UIKit

class ExamTableViewCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    func prepare(with exam: ExamItem) {
        titleLabel.text = exam.title
        tagView.backgroundColor = exam.isCompleted ? .orange : .lightGray
        
        if let date = exam.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
    }
}
