//
//  DetailsViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class DetailsViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var dueLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var prioritylabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.appStateStore.subscribe(self) { $0.select { $0.detailsState } }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dependency.appStateStore.unsubscribe(self)
    }
    
    func newState(state: DetailsState) {
        titleLabel?.text = state.examinedTodo?.title
        dueLabel?.text = state.examinedTodo
            .map { dependency.formatter(time: .short, date: .short).string(from: $0.dueBy) }
        //descriptionLabel //??
        prioritylabel?.text = state.examinedTodo?.priority.description
    }
    
    @IBAction func edit() {
        guard let todo = dependency.appStateStore.state.detailsState.examinedTodo
            else { return }
        dependency.appStateStore.dispatch(EditActions.edit(todo))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier,
            R.storyboard.main.details.identifier
            ], animated: false))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier,
            R.storyboard.main.details.identifier,
            R.storyboard.main.edit.identifier
            ]))
    }
    
    @IBAction func delete() {
        guard let todo = dependency.appStateStore.state.detailsState.examinedTodo
            else { return }
        dependency.appStateStore.dispatch(DetailsAction.delete(todo: todo))
        dependency.appStateStore.dispatch(SetRouteAction([
            R.storyboard.main.navigation.identifier,
            R.storyboard.main.list.identifier
            ]))
    }
}
