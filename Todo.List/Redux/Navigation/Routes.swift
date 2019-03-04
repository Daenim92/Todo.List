//
//  Router.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/2/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwiftRouter
import Rswift

extension RouteElementIdentifier {
    func asVCRoutable() throws -> VCRoutable {
        let sbRes = R.storyboard.main
        let sb = R.storyboard.main()
        switch self {
        case sbRes.access.identifier,
             sbRes.list.identifier,
             sbRes.details.identifier,
             sbRes.edit.identifier,
             sbRes.reminders.identifier,
             sbRes.navigation.identifier:
            return VCRoutable(sb.instantiateViewController(withIdentifier: self))
        default: throw "Unsupported route identifier: \(self)"
        }
    }
}

class VCRoutable: Routable {
    let vc: UIViewController
    
    init(_ vc: UIViewController) {
        self.vc = vc
    }
    
    func getNav() -> UINavigationController? { return vc.navigationController ?? (vc as? UINavigationController) }
    
    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable
    {
        let routable = try! routeElementIdentifier.asVCRoutable()
        if let nav = getNav() {
            nav.pushViewController(routable.vc, animated: animated)
        }
        completionHandler()
        return routable
    }
    
    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        self.popRouteSegment(from, animated: animated) { }
        return self.pushRouteSegment(to, animated: animated, completionHandler: completionHandler)
    }
    
    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler)
    {
        if let nav = getNav() {
            nav.popToViewController(self.vc, animated: animated)
        }
        completionHandler()
    }
}

class WindowRoutable: Routable {
    let window: UIWindow
    
    init(_ window: UIWindow = UIApplication.shared.keyWindow ?? UIWindow()) {
        self.window = window
    }
    
    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let routable = try! routeElementIdentifier.asVCRoutable()
        self.window.becomeKey()
        self.window.isHidden = false
        self.window.rootViewController = routable.vc
        completionHandler()
        return routable
    }
    
    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let routable = try! to.asVCRoutable()
        self.window.rootViewController = routable.vc
        completionHandler()
        return routable
    }
    
    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {
        self.window.rootViewController = nil
        completionHandler()
    }
}

