//
//  SignUpInViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 2/26/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwift

class SignUpInViewController: UIViewController {
    
    @IBOutlet weak var typeSwitch: UISwitch?
    @IBOutlet weak var usernameInput: UITextField?
    @IBOutlet weak var passwordInput: UITextField?
    @IBOutlet weak var errorLabel: UILabel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.appStateStore.subscribe(self) { $0.select { $0.accessState } }
        
        #if DEBUG
        dependency.appStateStore.dispatch(UserAccessActions.typedUser("dmytro.bayda.dev@gmail.com"))
        dependency.appStateStore.dispatch(UserAccessActions.typedPassword("hello"))
        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dependency.appStateStore.unsubscribe(self)
    }
}

extension SignUpInViewController: StoreSubscriber {
    func newState(state: AccessState) {
        self.typeSwitch?.isOn = state.buttonSignUpType.rawValue
        self.errorLabel?.text = state.error?.localizedDescription
    }
}

extension SignUpInViewController {
    @IBAction func textTyped(_ sender: UITextField) {
        switch sender {
        case usernameInput:
            dependency.appStateStore.dispatch(UserAccessActions.typedUser(sender.text))
        case passwordInput:
            dependency.appStateStore.dispatch(UserAccessActions.typedPassword(sender.text))
        default:
            break
        }
    }
    @IBAction func buttonAction() {
        dependency.appStateStore.dispatch(UserAccessActions.buttonAction())
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        dependency.appStateStore.dispatch(UserAccessActions.switchButtonType(sender.isOn.asActionType))
    }
}

//helpers

extension Bool {
    var asActionType: AccessState.ButtonType { return AccessState.ButtonType.init(rawValue: self) }
}

extension AccessState.ButtonType: RawRepresentable {
    init(rawValue: Bool) {
        self = rawValue ? .signIn : .signUp
    }
    
    var rawValue: Bool {
        switch self {
        case .signIn: return true
        case .signUp: return false
        }
    }
}
