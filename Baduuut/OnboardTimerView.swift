//
//  OnboardTimerView.swift
//  Baduuut
//
//  Created by Leo Harnadi on 22/03/23.
//

import SwiftUI

extension OnboardPage{
    final class ViewModel: ObservableObject{
        @Published var hasFinished = false
        @Published var isActive = false
        @Published var time: String = "00:00:00"
        @Published var seconds: Float = 15
        
        private var initialTime = 0
        private var endDate = Date()

        
        func start(seconds: Float) {
            self.hasFinished = false
            self.initialTime = Int(seconds)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .second, value: Int(seconds), to: endDate)!
            UserDefaults.standard.set(self.endDate, forKey: "timer_end_date")
            
            let content = UNMutableNotificationContent()
            content.title = "Time's up!"
            content.subtitle = reminderMessages.randomElement()!
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            
            let request = UNNotificationRequest(identifier: "BADUUUT_STRETCH_NOTIF_ID", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        func reset() {
            self.seconds = Float(initialTime)
            self.isActive = false
            self.time = "00:00:00"
            self.endDate = Date()
        }
        
        func updateCountdown(){
//            guard isActive else { return }
            self.endDate = UserDefaults.standard.object(forKey: "timer_end_date") as? Date ?? self.endDate

            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970

            if diff <= 0 {
                if UserDefaults.standard.object(forKey: "timer_end_date") != nil{
                    hasFinished = true
                    UserDefaults.standard.set(nil, forKey: "timer_end_date")
                } else {
                    hasFinished = false
                }
                self.isActive = false
                self.time = "00:00:00"
                return
            } else {
                self.isActive = true
                self.hasFinished = false
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let hours = (calendar.component(.hour, from: date))-7 //kyknya -7 soalnya WIB = +7 UTC?
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.seconds = Float(seconds)
            self.time = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        //Calculate time value from string input (from picker)
        func extractTime (selected: String) -> Float {
            let start = selected.startIndex
            let end = selected.endIndex
            let space = selected.index(start, offsetBy: 6)
            let space2 = selected.index(start, offsetBy: 8)
            var timeUnit = String(selected[space2..<end])
            var time = String(selected[space..<space2])
            time = time.trimmingCharacters(in: .whitespacesAndNewlines)
            timeUnit = timeUnit.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var timeInSeconds: Float
            
            switch timeUnit {
            case "hour"..."hours":
                timeInSeconds = Float(time)! * 3600
            case "minutes":
                timeInSeconds = Float(time)! * 60
            default:
                timeInSeconds = Float(time)!
            }

            return timeInSeconds
        }
    }
}

