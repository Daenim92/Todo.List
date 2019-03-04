//
//  EditViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class EditViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var titleLabel: UITextView?
    @IBOutlet weak var descriptionLabel: UITextView?
    @IBOutlet weak var duePicker: UIDatePicker?
    @IBOutlet weak var priorityPicker: UISegmentedControl?
    @IBOutlet weak var reminderPicker: UIDatePicker?
    @IBOutlet weak var reminderSwitch: UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.setupDismissal()
        descriptionLabel?.setupDismissal()
        
        priorityPicker?.removeAllSegments()
        Todo.Priority.allCases.enumerated().forEach {
            priorityPicker?.insertSegment(withTitle: $0.element.description, at: $0.offset, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.appStateStore.subscribe(self) { $0.select { $0.editState }}
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dependency.appStateStore.unsubscribe(self)
    }

    func newState(state: EditState) {
        titleLabel?.text = state.editedTodo?.title
        descriptionLabel?.text = ""
        duePicker?.date = state.editedTodo?.dueBy ?? Date()
        priorityPicker?.selectedSegmentIndex = state.editedTodo
            .map { Todo.Priority.allCases.firstIndex(of: $0.priority) ?? 0 } ?? 0
        reminderPicker?.isEnabled = state.editedTodo?.notificationBefore != nil
        reminderPicker?.countDownDuration = state.editedTodo?.notificationBefore ?? 10.0
        reminderSwitch?.isOn = state.editedTodo?.notificationBefore != nil
    }
    
    @IBAction func editedPriority(_ sender: UISegmentedControl) {
        let newPriority = Todo.Priority.allCases[sender.selectedSegmentIndex]
        dependency.appStateStore.dispatch(EditActions.editPriority(newPriority))
    }
    
    @IBAction func editedDue(_ sender: UIDatePicker) {
        let due = sender.date
        dependency.appStateStore.dispatch(EditActions.editDue(due))
    }
    
    @IBAction func save() {
        if let todo = dependency.appStateStore.state.editState.editedTodo {
            let store = dependency.appStateStore
            store.dispatch(EditActions.save(todo: todo))
            store.dispatch(DetailsAction.examine(todo))
            store.dispatch(SetRouteAction([
                R.storyboard.main.navigation.identifier,
                R.storyboard.main.list.identifier
                ]))
        }
    }
    
    @IBAction func toggleNotification() {
        reminderPicker?.isEnabled.toggle()
        let timer: TimeInterval? = {
            guard let reminder = reminderPicker else { return nil }
            guard reminder.isEnabled else { return nil }
            
            return reminder.countDownDuration
        }()
        dependency.appStateStore.dispatch(EditActions.editReminder(timer))
    }

}

extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView{
        case titleLabel:
            dependency.appStateStore.dispatch(EditActions.editTitle(textView.text))
        case descriptionLabel:
            dependency.appStateStore.dispatch(EditActions.editDescription(textView.text))
        default: break
        }

    }
}

extension Todo.Priority {
    static var allCases: [Todo.Priority] { return [.high, .normal, .low] }
}
