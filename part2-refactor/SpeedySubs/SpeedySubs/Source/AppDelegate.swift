import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let initialViewController = LoginViewController(navDelegate: self)
        window?.rootViewController = UINavigationController(rootViewController: initialViewController)
        window!.makeKeyAndVisible()

        return true
    }

}

extension AppDelegate: LoginNavDelegate {
    func advanceToChooseSandwichScreen() {
        let nextViewController = ChooseSandwichViewController.build(navDelegate: self)
        (window?.rootViewController as? UINavigationController)?.viewControllers.append(nextViewController)
    }
}

extension AppDelegate: ChooseSandwichNavDelegate {
    func advanceToChooseCardScreen() {
        let nextViewController = ChooseCardViewController.build(navDelegate: self)
        (window?.rootViewController as? UINavigationController)?.viewControllers.append(nextViewController)
    }
}

extension AppDelegate: ChooseCardNavDelegate {
    func advanceToConfirmationScreen() {
        let nextViewController = ConfirmationViewController.build(navDelegate: self)
        (window?.rootViewController as? UINavigationController)?.setViewControllers([nextViewController], animated: true)
    }
}
