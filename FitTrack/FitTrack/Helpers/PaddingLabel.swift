//
//  PaddingLabel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import UIKit    

class PaddingLabel: UILabel {
    
    var textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
