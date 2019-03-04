//
//  AccessActions.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import ReSwiftRouter
import Alamofire
import CodableAlamofire

enum UserAccessActions: Action {
    case switchButtonType(AccessState.ButtonType)
    case typedUser(String?)
    case typedPassword(String?)
}

enum InternalAccessAction: Action {
    case setAccess(AccessState.AccessType)
    case gotError(Error)
}

extension UserAccessActions {
    static func buttonAction(_ apiSession: API = dependency.apiSession, _ decoder: JSONDecoder = dependency.apiDecoder)
        -> Store<AppState>.ActionCreator
    {
        return { state, store in
            switch state.accessState.buttonSignUpType {
            case .signIn:
                store.dispatch(signIn(apiSession, decoder) )
                
            case .signUp:
                store.dispatch(signUp(apiSession, decoder))
            }
            
            return nil
        }
    }
    
    static func signIn(_ apiSession: API = dependency.apiSession, _ decoder: JSONDecoder = dependency.apiDecoder)
        -> Store<AppState>.ActionCreator
    {
        return { state, store in
            let data = state.accessState.getUserPass()
            
            apiSession.signIn(user: data.user, password: data.pass)
                .responseDecodableObject(decoder: decoder) { (response: DataResponse<SignInResponse>) in
                    switch response.result {
                    case .success(let value):
                        store.dispatch(InternalAccessAction.setAccess(.token(value.token)))
                        store.dispatch(SetRouteAction([
                            R.storyboard.main.navigation.identifier,
                            R.storyboard.main.list.identifier
                            ]))
                    case .failure(let error):
                        store.dispatch(InternalAccessAction.gotError(error))
                    }
            }
            
            return nil
        }
    }
    
    static func signUp(_ apiSession: API = dependency.apiSession, _ decoder: JSONDecoder = dependency.apiDecoder)
        -> Store<AppState>.ActionCreator
    {
        return { state, store in
            let data = state.accessState.getUserPass()
            
            apiSession.signUp(user: data.user, password: data.pass)
                .responseDecodableObject(decoder: decoder) { (response: DataResponse<SignUpResponse>) in
                    switch response.result {
                    case .success(let value):
                        store.dispatch(InternalAccessAction.setAccess(.token(value.token)))
                        store.dispatch(SetRouteAction([
                            R.storyboard.main.navigation.identifier,
                            R.storyboard.main.list.identifier
                            ]))
                    case .failure(let error):
                        store.dispatch(InternalAccessAction.gotError(error))
                    }
                }
            
            return nil
        }
    }
}

fileprivate extension AccessState {
    func getUserPass() -> (user: String, pass:String) {
        return (self.typedUser ?? "", self.typedPassword ?? "")
    }
}
