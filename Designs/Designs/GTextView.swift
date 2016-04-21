//
//  GTextView.swift
//  Designs
//
//  Created by Prithiviraj on 19/04/16.
//  Copyright © 2016 Teksystems. All rights reserved.
//

import UIKit
private let kGTextViewInsetSpan: CGFloat = 8
@IBDesignable
class GTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: PROPERTIES
    
    @IBInspectable var placeholder: NSString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor()
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
            clipsToBounds = true
        }
    }
    
    // MARK: - Text insertion methods need to "remove" the placeholder when needed
    
    /** Override normal text string */
    override var text: String! { didSet { setNeedsDisplay() } }
    
    /** Override attributed text string */
    override var attributedText: NSAttributedString! { didSet { setNeedsDisplay() } }
    
    /** Setting content inset needs a call to setNeedsDisplay() */
    override var contentInset: UIEdgeInsets { didSet { setNeedsDisplay() } }
    
    /** Setting font needs a call to setNeedsDisplay() */
    override var font: UIFont? { didSet { setNeedsDisplay() } }
    
    /** Setting text alignment needs a call to setNeedsDisplay() */
    override var textAlignment: NSTextAlignment { didSet { setNeedsDisplay() } }
    
    // MARK: - Lifecycle
    
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
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornurRadius
    }
    
    /** Override coder init, for IB/XIB compatibility */
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        listenForTextChangedNotifications()
    }
    
    /** Override common init, for manual allocation */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        listenForTextChangedNotifications()
    }
    #endif
    
    /** Initializes the placeholder text view, waiting for a notification of text changed */
    func listenForTextChangedNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChangedForGTextView:", name:UITextViewTextDidChangeNotification , object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChangedForGTextView:", name:UITextViewTextDidBeginEditingNotification , object: self)
    }
    
    /** willMoveToWindow will get called with a nil argument when the window is about to dissapear */
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if newWindow == nil { NSNotificationCenter.defaultCenter().removeObserver(self) }
        else { listenForTextChangedNotifications() }
    }
    
    
    // MARK: - Adjusting placeholder.
    func textChangedForGTextView(notification: NSNotification) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // in case we don't have a text, put the placeholder (if any)
        if self.text.characters.count == 0 && self.placeholder != nil {
            let baseRect = placeholderBoundsContainedIn(self.bounds)
            let font = self.font ?? self.typingAttributes[NSFontAttributeName] as? UIFont ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
            
            self.placeholderColor.set()
            
            // build the custom paragraph style for our placeholder text
            var customParagraphStyle: NSMutableParagraphStyle!
            if let defaultParagraphStyle =  typingAttributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
                customParagraphStyle = defaultParagraphStyle.mutableCopy() as! NSMutableParagraphStyle
            } else { customParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle }
            // set attributes
            customParagraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            customParagraphStyle.alignment = self.textAlignment
            let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: customParagraphStyle.copy() as! NSParagraphStyle, NSForegroundColorAttributeName: self.placeholderColor]
            // draw in rect.
            self.placeholder?.drawInRect(baseRect, withAttributes: attributes)
        }
    }
    
    func placeholderBoundsContainedIn(containerBounds: CGRect) -> CGRect {
        // get the base rect with content insets.
        let baseRect = UIEdgeInsetsInsetRect(containerBounds, UIEdgeInsetsMake(kGTextViewInsetSpan, kGTextViewInsetSpan/2.0, 0, 0))
        
        // adjust typing and selection attributes
        if let paragraphStyle = typingAttributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            return baseRect.offsetBy(dx: paragraphStyle.headIndent, dy: paragraphStyle.firstLineHeadIndent)
        }
        
        return baseRect
    }}
