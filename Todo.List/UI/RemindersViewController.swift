//
//  RemindersViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import UserNotifications
import ReSwift

class RemindersViewController: UIViewController, StoreSubscriber {
    
    var reminders: [UNNotificationRequest] = []
    
    @IBOutlet weak var tableView: UITableView?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.appStateStore.subscribe(self) { $0.select{ $0.notificationState }}
        
        dependency.appStateStore.dispatch(NotificationActions.getAll())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dependency.appStateStore.unsubscribe(self)
    }
    
    func newState(state: NotificationState) {
        self.reminders = state.reminders
        tableView?.reloadData()
    }

}

extension RemindersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.reminderCell, for: indexPath)!
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.content.title
        cell.detailTextLabel?.text = (reminder.content.userInfo[NotificationState.userInfoTriggerDate] as? Date)
            .map { dependency.formatter(time: .short, date: .short).string(from: $0) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
        dependency.appStateStore.dispatch(NotificationActions.remove(reminder))
        dependency.appStateStore.dispatch(NotificationActions.getAll())
    }
}
