//
//  ViewController.swift
//  Example
//
//  Created by Khoa Pham on 19/07/2022.
//

import UIKit
import TSAnimatedPopup

class ViewController: UIViewController {

    var animatedPopup: AnimatedPoup!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        
        let icons = [UIImage(named: "blue_like"),
                     UIImage(named: "red_heart"),
                     UIImage(named: "cry_laugh"),
                     UIImage(named: "surprised"),
                     UIImage(named: "cry"),
                     UIImage(named: "angry")].compactMap { image in
            return image
        }
        
        animatedPopup = AnimatedPoup(view, images: icons)
        animatedPopup.delegate = self
        animatedPopup.options.itemWidth = 40
    }

}

extension ViewController: AnimatedPopupDelegate {
    func animatedPopup(_ animatedPopup: AnimatedPoup, didSelectItemAt index: Int) {
        print(index)
    }
    
    func askForItemContainerViewLocation(_ animatedPopup: AnimatedPoup, pressedAt location: CGPoint) -> CGPoint {
        let x = (animatedPopup.containerView.frame.width - animatedPopup.iconsContainerView.frame.width) / 2
        let y = location.y - animatedPopup.iconsContainerView.frame.height * 2
        return CGPoint(x: x, y: y)
    }
}

