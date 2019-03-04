//
//  RoutedNavigationViewController.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit
import ReSwiftRouter

class RoutedNavigationViewController: UINavigationController, Routable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return nil
    }
    
}
