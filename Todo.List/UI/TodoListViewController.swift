//
//  TodoListViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class TodoListViewController: UIViewController, StoreSubscriber {
    
    var todoStore: [Page] = []
    
    @IBOutlet weak var todoTableView: UITableView?
    @IBOutlet weak var sortingPicker: UIPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refresh), for: .valueChanged)
        todoTableView?.refreshControl = r
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.appStateStore.subscribe(self) { $0.select { $0.todoListState } }
        
        refresh()
    }
    
    func newState(state: TodoListState) {
        self.todoStore = state.todos.values.sorted{ $0.meta.current < $1.meta.current }
        self.todoTableView?.reloadData()
        state.isLoading ? todoTableView?.refreshControl?.beginRefreshing() : todoTableView?.refreshControl?.endRefreshing()
    }
    
    @objc func refresh() {
        dependency.appStateStore.dispatch(TodoListActions.setData([:]))
        dependency.appStateStore.dispatch(TodoListActions.getTodos(page: 0))
    }
    
    @IBAction func createNew() {
        let todo = Todo(title: "", dueBy: Date(), priority: .normal)
        dependency.appStateStore.dispatch(EditActions.edit(todo))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier
            ], animated: false))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier,
            R.storyboard.main.edit.identifier
            ]))
    }
    
    @IBAction func sort() {
        guard let picker = sortingPicker else { return }
        picker.isHidden.toggle()
        if picker.isHidden {
            let key = Sort.options.0[picker.selectedRow(inComponent: 0)].0
            let type = Sort.options.1[picker.selectedRow(inComponent: 1)]
            
            let sort = Sort(by: key, type: type)
            dependency.appStateStore.dispatch(TodoListActions.sort(sort))
            refresh()
        }
    }
    
    @IBAction func reminders() {
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier
            ], animated: false))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier,
            R.storyboard.main.reminders.identifier
            ]))
    }
}

//MARK: Table part

class TodoListTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var dueLabel: UILabel?
    @IBOutlet weak var priorityLabel: UILabel?
}

extension TodoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoStore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoStore[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.todoCell, for: indexPath)!
        
        //listen to end of
        let todo = todoStore[indexPath.section].tasks[indexPath.row]
        
        
        
        cell.dueLabel?.text = dependency.formatter(time: .none, date: .short).string(from: todo.dueBy)
        cell.titleLabel?.text = todo.title
        cell.priorityLabel?.text = todo.priority.description
        
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0//UITableView.automaticDimension
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height * 0.8)
        {
            dependency.appStateStore.dispatch(TodoListActions.getNextPage())
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let todo = todoStore[indexPath.section].tasks[indexPath.row]
        dependency.appStateStore.dispatch(DetailsAction.examine(todo))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier
            ], animated: false))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier,
            R.storyboard.main.details.identifier
            ]))
        return nil
    }
}

//MARK: picker part

extension Sort {
    static let options: ([(Todo.CodingKeys, String)], [Sort.SortType]) =
        ([(.dueBy, "Due time"), (.title, "Title"), (.priority, "Priority")], [.ascending, .descending])
}

extension TodoListViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return Sort.options.0.count
        case 1:
            return Sort.options.1.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return Sort.options.0[row].1
        case 1:
            return Sort.options.1[row].rawValue.capitalized
        default:
            return ""
        }
    }
}
