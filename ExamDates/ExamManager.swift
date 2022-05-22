//
//  ExamManager.swift
//  ExamDates
//
//  Created by Muallim on 22.05.2022.
//

import Foundation

class ExamManager {
    private let dataSourceURL : URL
    private var allExams: [ExamItem] {
        get {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: dataSourceURL)
                let decodedExams = try!
                    decoder.decode([ExamItem].self, from: data)
                
                return decodedExams
            } catch {
                return []
            }
        }
        set {
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(newValue)
                
                try data.write(to: dataSourceURL)
            } catch {
                
            }
        }
    }
    
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
        let examsPath = documentsPath.appendingPathComponent("exams").appendingPathExtension("plist")
        
        dataSourceURL = examsPath
    }
    
    func getAllExams() -> [ExamItem] {
        return allExams
    }
    
    func create(exam: ExamItem) {
        allExams.insert(exam, at: 0)
        
        if let date = exam.date {
            NotificationProvider.scheduleNotification(title: exam.title, date: exam.date!, id: exam.id)
        }
    }
    
    func setComplete(exam: ExamItem) {
        if let index = allExams.firstIndex(where: { $0.id == exam.id }) {
            allExams[index].isCompleted.toggle()
        }
    }
    
    func delete(exam: ExamItem) {
        if let index = allExams.firstIndex(where: { $0.id == exam.id }) {
            allExams.remove(at: index)
            NotificationProvider.cancelNotification(exam.id)
        }
    }
}
