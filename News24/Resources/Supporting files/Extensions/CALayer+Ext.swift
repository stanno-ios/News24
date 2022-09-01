//
//  UIView+Ext.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import QuartzCore
import UIKit

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, widthAdjustment: CGFloat, inset: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: inset, y: 0, width: frame.width + widthAdjustment, height: thickness)
        case .bottom:
            border.frame = CGRect(x: inset, y: frame.height - thickness, width: frame.width + widthAdjustment, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: inset, width: thickness, height: frame.height + widthAdjustment)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: inset, width: thickness, height: frame.height + widthAdjustment)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}
