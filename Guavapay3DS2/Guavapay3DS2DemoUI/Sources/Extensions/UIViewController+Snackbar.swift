//
//  UIViewController+Snackbar.swift
//  Guavapay3DS2
//

import UIKit

extension UIViewController {
    /// Show snackbar on the screen with provided message text and background color (based on `isError` flag)
    /// - Parameters:
    ///   - text: message text to show
    ///   - isError: should alert background color be used
    func showSnackbar(_ text: String?, isError: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let snackbarHeight: CGFloat = 50
        let sideInset: CGFloat = 16
        let yPosition = window.bounds.height - snackbarHeight - window.safeAreaInsets.bottom
        let frame = CGRect(
            x: sideInset,
            y: yPosition,
            width: window.bounds.width - sideInset * 2,
            height: snackbarHeight
        )

        let snackbar = UILabel(frame: frame)
        snackbar.backgroundColor = isError ? .init(red: 0.65, green: 0.1, blue: 0.1, alpha: 1) : .label
        snackbar.textColor = .systemBackground
        snackbar.textAlignment = .center
        snackbar.font = .systemFont(ofSize: 14)
        snackbar.layer.cornerRadius = snackbarHeight / 4
        snackbar.clipsToBounds = true
        snackbar.numberOfLines = 3
        snackbar.text = text

        window.addSubview(snackbar)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            snackbar.removeFromSuperview()
        }
    }
}
