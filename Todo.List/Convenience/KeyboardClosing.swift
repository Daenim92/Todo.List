//
//  KeyboardClosing.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import UIKit

class KeyboardClosing: NSObject {
    @IBAction func endEditing(_ sender: UIControl) {
        sender.endEditing(true)
    }
}

extension UITextView {
    func setupDismissal(title: String = "Done") {
        let toolbar = UIToolbar()
        
        let doneButt = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(resignFirstResponder))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButt], animated: false)
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }
}
