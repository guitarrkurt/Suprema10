//
//  ADVSegmentedControl.swift
//  Mega
//
//  Created by Tope Abayomi on 01/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//
import UIKit
@IBDesignable
public class ADVSegmentedControl: UIControl {
    public var labels = [UILabel]()
    var thumbView = UIView()
    var items: [String] = ["Todo", "Pastor", "Árabe", "Bebida", "Promo", "⭐️"] {
        didSet {
            setupLabels()
        }
    }
    var bandera = true
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
//Errores anteriores
//    public init(WithFramea frame: CGRect){
//        super.init(frame: frame)
//        setupView()
//    }
    
//Corre bien
//    override public init(frame: CGRect){
//        super.init(frame: frame)
//        setupView()
//    }
//Corre bien
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        setupView()
//    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    @IBInspectable public var selectedLabelColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    @IBInspectable public var unselectedLabelColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    @IBInspectable public var thumbColor : UIColor = UIColor(patternImage: UIImage(named: "cafeFuerte.png")!) {
        didSet {
            setSelectedColors()
        }
    }
    @IBInspectable public var borderColor : UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    @IBInspectable public var font : UIFont! = UIFont.systemFontOfSize(7) {
        didSet {
            setFont()
        }
    }
    func setupView(){
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor.whiteColor().CGColor
        //UIColor(white: 1.0, alpha: 0.5).CGColor
        layer.borderWidth = 1
        backgroundColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!)
        setupLabels()
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        insertSubview(thumbView, atIndex: 0)
    }
    func setupLabels(){
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll(keepCapacity: true)
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRectMake(0, 0, 70, 40))
            label.text = items[index - 1]
            label.backgroundColor = UIColor.clearColor()
//          UIColor(red: 167.0, green: 121.0, blue: 66.0, alpha: 1.0)
            label.textAlignment = .Center
//            label.font = UIFont(name: "Avenir-Black", size: 15)
            label.font = UIFont(name: "System", size: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        displayNewSelectedIndex()
    }
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        var calculatedIndex : Int?
        for (index, item) in labels.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        return false
    }
    func displayNewSelectedIndex(){
        for (_, item) in labels.enumerate() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            
            self.thumbView.frame = label.frame
            
            }, completion: nil)
    }
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerate() {
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            var rightConstraint : NSLayoutConstraint!
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -padding)
            }else{
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: nextButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -padding)
            }
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: padding)
            }else{
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: prevButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
                let firstItem = items[0]
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: firstItem, attribute: .Width, multiplier: 1.0  , constant: 0)
                mainView.addConstraint(widthConstraint)
            }
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        thumbView.backgroundColor = thumbColor
    }
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
}
