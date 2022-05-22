//
//  ExamItem.swift
//  ExamDates
//
//  Created by Muallim on 22.05.2022.
//

import Foundation

struct ExamItem : Codable {
    var id = UUID().uuidString
    var title : String
    var date : Date?
    var isCompleted = false
}
