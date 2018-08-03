//
//  ViewController.swift
//  LoginExample
//
//  Created by David Beck on 8/3/18.
//  Copyright © 2018 David Beck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBAction func logout(_ sender: Any) {
		self.authenticationViewController?.logout()
	}
}
