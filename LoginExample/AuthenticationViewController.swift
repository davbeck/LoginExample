import UIKit


class AuthenticationViewController: UIPageViewController {
	private let sessionPreferenceKey = "LoginSession"
	private(set) var session: String?
	
	private func login(session: String) {
		guard self.session != session else { return }
		self.session = session
		UserDefaults.standard.set(session, forKey: sessionPreferenceKey)
		
		update(animated: true)
	}
	
	func logout() {
		guard self.session != nil else { return }
		self.session = nil
		UserDefaults.standard.removeObject(forKey: sessionPreferenceKey)
		
		update(animated: true)
	}
	
	private func commonInit() {
		self.session = UserDefaults.standard.value(forKey: sessionPreferenceKey) as? String
	}
	
	init() {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
		
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		commonInit()
	}
	
	
	// MARK - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		update()
	}
	
	
	// MARK: - Root View Controller
	
	public var currentViewController: UIViewController? {
		get {
			return viewControllers?.first
		}
		set {
			let viewControllers = newValue.map({ [$0] })
			setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
		}
	}
	
	public func set(currentViewController viewController: UIViewController, direction: UIPageViewControllerNavigationDirection, animated: Bool = true, completion: (() -> Void)? = nil) {
		guard currentViewController != viewController else { completion?(); return }
		
		if let window = self.view.window, animated {
			let direction: UIViewAnimationOptions = (direction == .forward) ? .transitionFlipFromRight : .transitionFlipFromLeft
			UIView.transition(with: window, duration: 0.75, options: [.layoutSubviews, direction], animations: {
				self.currentViewController = viewController
			}) { completed in
				completion?()
			}
		} else {
			currentViewController = viewController
			completion?()
		}
	}
	
	private func update(animated: Bool = false) {
		if session == nil {
			let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login") as! LoginViewController
			viewController.delegate = self
			set(currentViewController: viewController, direction: .reverse, animated: animated, completion: nil)
		} else {
			let viewController = self.storyboard!.instantiateViewController(withIdentifier: "Authenticated")
			set(currentViewController: viewController, direction: .forward, animated: animated, completion: nil)
		}
	}
}


extension AuthenticationViewController: LoginViewControllerDelegate {
	func loginViewController(_ loginViewController: LoginViewController, didLoginWithSession session: String) {
		self.login(session: session)
	}
}


extension UIViewController {
	var authenticationViewController: AuthenticationViewController? {
		if let authenticationViewController = parent as? AuthenticationViewController {
			return authenticationViewController
		}
		
		return parent?.authenticationViewController
	}
}
