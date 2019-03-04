//
//  NotificationState.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UserNotifications

struct NotificationState {
    var reminders: [UNNotificationRequest] = []
    var error: Error? = nil
}
