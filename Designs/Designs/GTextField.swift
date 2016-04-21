//
//  GTextField.swift
//  Designs
//
//  Created by Prithiviraj on 19/04/16.
//  Copyright © 2016 Teksystems. All rights reserved.
//

import UIKit

@IBDesignable
class GTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var line:UIView?
    var lineLayer:CALayer?
    //MARK: PROPERTIES
    @IBInspectable var lineColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            line?.backgroundColor = lineColor
            lineLayer?.backgroundColor = lineColor.CGColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            let canEditPlaceholderColor = self.respondsToSelector(Selector("setAttributedPlaceholder:"))
            
            if (canEditPlaceholderColor) {
                let placeHolderString = self.placeholder ?? ""
                self.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes:[NSForegroundColorAttributeName: placeholderColor]);
            }
        }
    }
    
    //MARK: Initializers
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience init() {
        self.init(frame:CGRectZero)
        setup()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup() {
        line = UIView.init()
        line?.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(line!)
        
        
        lineLayer = CALayer()
        lineLayer?.backgroundColor = UIColor.lightGrayColor().CGColor
        layer.addSublayer(lineLayer!)
    }
    
    func configure() {
        line?.backgroundColor = lineColor
        lineLayer?.backgroundColor = lineColor.CGColor
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line?.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
        lineLayer?.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    }

}
