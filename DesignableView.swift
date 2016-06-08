//
//  DesignableView.swift
//  demoTaxiBeat
//
//  Created by Angel Papamichail on 05/06/16.
//  Copyright © 2016 Angel Papamichail. All rights reserved.
//

import UIKit

@IBDesignable
public class DesignableView: UIView {
    @IBInspectable var shadowColor: UIColor = UIColor.clearColor()
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOffset: CGSize = CGSizeMake(0, 0)
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    //Mark: Overriden Methods
    ////////////////////////////////////////////////////////////////////////////
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if 0 < self.shadowOpacity  {
            layer.shadowColor = self.shadowColor.CGColor
            layer.shadowOpacity = self.shadowOpacity
            layer.shadowRadius = self.shadowRadius
            layer.shadowOffset = self.shadowOffset
            
            if 0 < self.cornerRadius {
                layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                                cornerRadius: self.cornerRadius).CGPath
            } else {
                layer.shadowPath = UIBezierPath(rect: layer.bounds).CGPath
            }
        }
    }
}
