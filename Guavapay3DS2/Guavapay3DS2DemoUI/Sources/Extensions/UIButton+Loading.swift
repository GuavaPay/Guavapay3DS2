//
//  UIButton+Loading.swift
//  Guavapay3DS2
//

import UIKit

extension UIButton {
    /// Show spinner view on button
    func showLoading() {
        subviews.forEach { subview in
            if let indicator = subview as? UIActivityIndicatorView {
                indicator.removeFromSuperview()
            }
        }

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    /// Hide spinner view from button
    func hideLoading() {
        subviews.forEach { subview in
            if let indicator = subview as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
