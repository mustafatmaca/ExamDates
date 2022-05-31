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
            NotificationProvider.scheduleNotification(title: exam.title, date: exam.date!, id: exam.id)
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
