//
//  AppDelegate.swift
//  Guavapay3DS2DemoUI
//

import UIKit
import Guavapay3DS2

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let imageLoader = GPTDSImageLoader(urlSession: URLSession.shared)
        let demoViewController = DemoViewController(imageLoader: imageLoader)
        let navigationController = UINavigationController(rootViewController: demoViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        true
    }
}
