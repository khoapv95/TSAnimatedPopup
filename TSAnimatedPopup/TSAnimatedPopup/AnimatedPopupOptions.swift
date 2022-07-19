//
//  AnimatedPopupOptions.swift
//  TSAnimatedPopup
//
//  Created by Khoa Pham on 16/07/2022.
//

import UIKit

public struct AnimatedPopupOptions {
    /// This property is used to generate space between arranged views of the stack view
    public var padding: CGFloat = 6.0
    /// The width value of stack view arranged views
    public var itemWidth: CGFloat = 32.0
    /// The corner radius to apply to arranged views of the stack view
    public var cornerRadius: CGFloat = 0
    /// The shadow color of the animated container view
    public var shadowColor: CGColor = UIColor(white: 0.4, alpha: 0.4).cgColor
    /// The shadow radius of the animated container view
    public var shadowRadius: CGFloat = 8.0
    /// The shadow opacity of the animated container view
    public var shadowOpacity: Float = 0.5
    /// The shadow offset of the animated container view
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    /// The total duration of the animations
    public var animationDuration: Double = 0.5
    /// The amount of time to wait before beginning the animations
    public var animationDelay: Double = 0
}
