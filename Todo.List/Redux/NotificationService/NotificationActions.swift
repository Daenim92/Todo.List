//
//  NotificationService.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import UserNotifications

enum NotificationActions: Action {
    case setPending([UNNotificationRequest])
    case gotError(Error)
}

extension NotificationActions {
    static func getAll() -> Store<AppState>.ActionCreator {
        return { state, store in
            UNUserNotificationCenter.current().getPendingNotificationRequests { r in
                DispatchQueue.main.async {
                    store.dispatch(NotificationActions.setPending(r))
                }
            }
            return nil
        }
    }
    
    static func add(_ todo: Todo) -> Store<AppState>.ActionCreator {
        return { state, store in
            
            guard let before = todo.notificationBefore  else {
                store.dispatch(NotificationActions.gotError("Cannot add this reminder"))
                return nil
            }
            
            guard let id = todo.globalID() else {
                store.dispatch(NotificationActions.gotError("Cannot add this reminder"))
                return nil
            }

            let newDate = todo.dueBy.addingTimeInterval(0 - abs(before))
            let calendar = Calendar.autoupdatingCurrent
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.minute], from: newDate), repeats: false)
            
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.defaultCritical
            content.title = todo.title
            content.userInfo[NotificationState.userInfoTriggerDate] = newDate
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                guard let error = error else {
                    store.dispatch(NotificationActions.getAll())
                    return
                }
                store.dispatch(NotificationActions.gotError(error))
            }

            return nil
        }
    }
    
    static func remove(_ reminder: UNNotificationRequest) -> Store<AppState>.ActionCreator {
        return { state, store in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.identifier])
            store.dispatch(NotificationActions.getAll())
            
            return nil
        }
    }
    
    static func remove(_ todo: Todo) -> Store<AppState>.ActionCreator {
        return { state, store in
            guard let id = todo.globalID() else { return nil }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            store.dispatch(NotificationActions.getAll())
            
            return nil
        }
    }
}

//helpers

extension NotificationState {
    static let userInfoTriggerDate: String = "userInfoTriggerDate"
}

extension Todo {
    func globalID() -> String? {
        return id.map { "com.todo.list.test.reminder.\($0)" }
    }
}

