//
//  UIView+Corners.swift
//  AssignmentApp
//
//  Created by Subhadeep Pal on 17/12/19.
//  Copyright © 2019 Subhadeep Pal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            if let shadowColour = layer.shadowColor {
                return UIColor(cgColor: shadowColour)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat {
        get {
            return layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }
    }
}
