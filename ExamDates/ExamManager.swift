//
//  ExamManager.swift
//  ExamDates
//
//  Created by Muallim on 22.05.2022.
//

import Foundation

//Exam'ların yönetimini sağlayan sınıf. Silme, oluşturma, hepsini getirme
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
    
    //allExams listesini döndürür.
    func getAllExams() -> [ExamItem] {
        return allExams
    }
    
    //allExams listesine ExamItem'ı insert eder. Notification oluşturur.
    func create(exam: ExamItem) {
        allExams.insert(exam, at: 0)
        
        if let date = exam.date {
            var examDate = exam.date
            
            switch exam.remainTime {
            case "5 Min":
                examDate?.addTimeInterval(-5 * 60)
            case "10 Min":
                examDate?.addTimeInterval(-10 * 60)
            case "15 Min":
                examDate?.addTimeInterval(-15 * 60)
            case "30 Min":
                examDate?.addTimeInterval(-30 * 60)
            case "45 Min":
                examDate?.addTimeInterval(-45 * 60)
            case "1 Hour":
                examDate?.addTimeInterval(-60 * 60)
            case "1 Hour 30 Min":
                examDate?.addTimeInterval(-90 * 60)
            case "2 Hour":
                examDate?.addTimeInterval(-120 * 60)
            default:
                examDate?.addTimeInterval(0)
            }
            NotificationProvider.scheduleNotification(title: exam.title, date: examDate!, id: exam.id)
            
        }
    }
    
    //Sınavın tamamlanıp tamamlanmadığını set eder.
    func setComplete(exam: ExamItem) {
        if let index = allExams.firstIndex(where: { $0.id == exam.id }) {
            allExams[index].isCompleted.toggle()
        }
    }
    
    //Sınavı allExams'dan siler, Notification'ı iptal eder.
    func delete(exam: ExamItem) {
        if let index = allExams.firstIndex(where: { $0.id == exam.id }) {
            allExams.remove(at: index)
            NotificationProvider.cancelNotification(exam.id)
        }
    }
}
