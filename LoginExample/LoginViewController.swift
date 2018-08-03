//
//  LoginViewController.swift
//  LoginExample
//
//  Created by David Beck on 8/3/18.
//  Copyright © 2018 David Beck. All rights reserved.
//

import UIKit


protocol LoginViewControllerDelegate: class {
	func loginViewController(_ loginViewController: LoginViewController, didLoginWithSession session: String)
}

class LoginViewController: UIViewController {
	weak var delegate: LoginViewControllerDelegate?
	
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBAction func login(_ sender: Any) {
		let session = emailField.text ?? ""
		delegate?.loginViewController(self, didLoginWithSession: session)
	}
}
