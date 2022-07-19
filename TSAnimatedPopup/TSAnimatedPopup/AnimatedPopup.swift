//
//  AnimatedPopup.swift
//  TSAnimatedPopup
//
//  Created by Khoa Pham on 13/07/2022.
//

import UIKit

public protocol AnimatedPopupDelegate: AnyObject {
    func animatedPopup(_ animatedPopup: AnimatedPoup, didSelectItemAt index: Int)
    func askForItemContainerViewLocation(_ animatedPopup: AnimatedPoup, pressedAt location: CGPoint) -> CGPoint
}

public class AnimatedPoup {
    
    // MARK: - Properties
    
    public let containerView: UIView
    private let images: [UIImage]
    
    public private(set) lazy var iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        var arrangedSubviews: [UIImageView] = []
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            arrangedSubviews.append(imageView)
        }
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width: CGFloat = numIcons * options.itemWidth + (numIcons + 1) * options.padding

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = options.padding
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: options.padding,
                                               left: options.padding,
                                               bottom: options.padding,
                                               right: options.padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)

        containerView.frame.size = CGSize(width: width, height: options.itemWidth + 2 * options.padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // Shadow configurations
        containerView.layer.shadowColor = options.shadowColor
        containerView.layer.shadowRadius = options.shadowRadius
        containerView.layer.shadowOpacity = options.shadowOpacity
        containerView.layer.shadowOffset = options.shadowOffset
        
        stackView.frame = containerView.frame
        
        return containerView
    }()
    
    private var beganPressedLocation: CGPoint = .zero
    
    public var options = AnimatedPopupOptions()
    public weak var delegate: AnimatedPopupDelegate?
    
    // MARK: - Initialize
    
    public init(_ containerView: UIView, images: [UIImage]) {
        self.containerView = containerView
        self.images = images
        setupLongPressGesture()
    }
    
    // MARK: - Helpers
    
    private func setupLongPressGesture() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        containerView.addGestureRecognizer(longPressGR)
    }
    
    // MARK: - Actions
    
    @objc
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            handleGestureBegan(gesture)
        case .changed:
            handleGestureChanged(gesture)
        case .ended:
            handleGestureEnded(gesture)
        default:
            return
        }
    }
}

// MARK: - Gesture handlers

extension AnimatedPoup {
    private func handleGestureBegan(_ gesture: UILongPressGestureRecognizer) {
        containerView.addSubview(iconsContainerView)

        let pressedLocation = gesture.location(in: containerView)
        
        guard let location = delegate?.askForItemContainerViewLocation(self, pressedAt: pressedLocation) else {
            return
        }
        
        iconsContainerView.transform = CGAffineTransform(translationX: location.x, y: pressedLocation.y)
                
        UIView.animate(withDuration: options.animationDuration,
                       delay: options.animationDelay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: location.x, y: location.y)
        }
        
        beganPressedLocation = pressedLocation
    }
    
    private func handleGestureChanged(_ gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: iconsContainerView)
                
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: iconsContainerView.frame.height / 2)
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {

            UIView.animate(withDuration: options.animationDuration,
                           delay: options.animationDelay,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut) {
                
                let stackView = self.iconsContainerView.subviews.first!
                stackView.subviews.forEach { imageView in
                    imageView.transform = .identity
                }
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            }
        }
    }
    
    private func handleGestureEnded(_ gesture: UILongPressGestureRecognizer) {
        // clean up the animation
        
        let y = beganPressedLocation.y - iconsContainerView.frame.origin.y
        
        UIView.animate(withDuration: options.animationDuration,
                       delay: options.animationDelay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            let stackView = self.iconsContainerView.subviews.first!
            stackView.subviews.forEach { imageView in
                if imageView.frame.origin.y < 0 {
                    self.delegate?.animatedPopup(self, didSelectItemAt: imageView.tag)
                }
                imageView.transform = .identity
            }
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: y)
            self.iconsContainerView.alpha = 0
        } completion: { _ in
            self.iconsContainerView.removeFromSuperview()
            self.beganPressedLocation = .zero
        }
    }
}
