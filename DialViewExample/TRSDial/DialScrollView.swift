/***************************************************
*  ____              ___   ____                   *
* |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
* | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
* |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
* |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
*                                                 *
***************************************************/
//
//  DialScrollView.swift
//  DialViewExample
//
//  Created by Kevin Kirkup on 6/9/14.
//  Copyright (c) 2014 TeaRoom Stdio. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DialScrollView : UIView {

    // Private Variables
    var min = 0
    var max = 0

    var scrollView : UIScrollView  = UIScrollView()
    var dialView : DialView
    var overlayView : UIView = UIView()

    func commonInit() {

        let contentHeight = bounds.size.height

        overlayView = UIView(frame: bounds)
        overlayView.userInteractionEnabled = false

        dialView = DialView(frame:CGRect(x:0, y:0, width:bounds.size.width, height:contentHeight))
        dialView.userInteractionEnabled = false;

        scrollView.frame = bounds

        // Disable Scrollbars
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.contentSize = CGSize(width: dialView.frame.size.width, height: contentHeight)

        // Setup Behavior
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.delegate = self

        scrollView.addSubview(dialView)
        addSubview(scrollView)
        addSubview(overlayView)
    }

    init(frame: CGRect) {

        dialView = DialView(frame: frame)
        super.init(frame: frame)
        commonInit()
    }

    init(coder aDecoder: NSCoder!) {

        dialView = DialView(coder: aDecoder)
        super.init(coder: aDecoder)
        commonInit()
    }

    // Public Variables

    /**
    * The current value in the scroll view
    */
    @IBInspectable
    var currentValue : Int {

        get {

            var minorTicksForOffset = roundf(scrollView.contentOffset.x / CGFloat(dialView.minorTickDistance))

            return Int(minorTicksForOffset) + dialView.minimum
        }

        set (newValue) {

            var constrained_value = newValue

            // Check to make sure the value is within the available range
            if ((newValue < min) || (newValue > max)) {
                constrained_value = min
            }

            // Update the content offset based on new value
            var offset = scrollView.contentOffset

            offset.x = CGFloat(constrained_value - dialView.minimum) * CGFloat(dialView.minorTickDistance)
            
            scrollView.contentOffset = offset;
        }
    }


    /**
    * The UIScrollViewDelegate for this class
    */
    @IBInspectable
    weak var delegate : UIScrollViewDelegate? = nil

    // mark - Generic Properties

    /**
    * The number of minor ticks per major tick
    */
    @IBInspectable
    var minorTicksPerMajorTick : Int {

        get {
            return dialView.minorTicksPerMajorTick
        }

        set  {
            dialView.minorTicksPerMajorTick = newValue
        }
    }

    /**
    * The number of pixels/points between minor ticks
    */
    @IBInspectable
    var minorTickDistance : Int {

        get {
            return dialView.minorTickDistance
        }

        set {
            dialView.minorTickDistance = newValue
        }
    }

    /**
    * The image to use as the background image
    */
    @IBInspectable
    var dialBackgroundColor : UIColor {

        get {
            return dialView.dialBackgroundColor
        }

        set {
            dialView.dialBackgroundColor = newValue
        }
    }

    /**
    * The image to overlay on top of the scroll dial
    */
    @IBInspectable
    var overlayColor : UIColor = UIColor.clearColor()

    // mark - Tick Label Properties

    /**
    * The tick label stroke color
    */
    @IBInspectable
    var labelStrokeColor : UIColor {

        get {
            return dialView.labelStrokeColor
        }

        set {
            dialView.labelStrokeColor = newValue
        }
    }

    /**
    * The width of the stroke line used to trace the Label text
    */
    @IBInspectable
    var labelStrokeWidth : CGFloat {

        get {
            return dialView.labelStrokeWidth
        }

        set {
            dialView.labelStrokeWidth = newValue
        }
    }

    /**
    * The tick label fill color
    */
    @IBInspectable
    var labelFillColor : UIColor {

        get {
            return dialView.labelFillColor
        }

        set {
            dialView.labelFillColor = newValue
        }
    }

    /**
    * The tick label font
    */
    @IBInspectable
    var labelFont : UIFont {

        get {
            return dialView.labelFont
        }

        set {
            dialView.labelFont = newValue
        }
    }

    // mark - Minor Tick Properties

    /**
    * The minor tick color
    */
    @IBInspectable
    var minorTickColor : UIColor {

        get {
            return dialView.minorTickColor
        }

        set {
            dialView.minorTickColor = newValue
        }
    }

    /**
    * The length of the minor ticks
    */
    @IBInspectable
    var minorTickLength : CGFloat {

        get {
            return dialView.minorTickLength
        }

        set {
            dialView.minorTickLength = newValue
        }
    }

    /**
    * The length of the Major Tick
    */
    @IBInspectable
    var minorTickWidth : CGFloat {

        get {
            return dialView.minorTickWidth
        }

        set {
            dialView.minorTickWidth = newValue
        }
    }

    // mark - Major Tick Properties

    /**
    * The color of the Major Tick
    */
    @IBInspectable
    var majorTickColor : UIColor {

        get {
            return dialView.majorTickColor
        }

        set {
            dialView.majorTickColor = newValue
        }
    }

    /**
    * The length of the Major Tick
    */
    @IBInspectable
    var majorTickLength : CGFloat {

        get {
            return dialView.majorTickLength
        }

        set {
            dialView.majorTickLength = newValue
        }
    }

    /**
    * The width of the Major Tick
    */
    @IBInspectable
    var majorTickWidth : CGFloat {

        get {
            return dialView.majorTickWidth
        }

        set {
            dialView.majorTickWidth = newValue
        }
    }

    // mark - Shadow Properties

    /**
    * The shadow color
    */
    @IBInspectable
    var shadowColor : UIColor {

        get {
            return dialView.shadowColor
        }

        set {
            dialView.shadowColor = newValue
        }
    }

    /**
    * The shadow offset
    */
    @IBInspectable
    var shadowOffset : CGSize {

        get {
            return dialView.shadowOffset
        }

        set {
            dialView.shadowOffset = newValue
        }
    }

    /**
    * The shadow blur radius
    */
    @IBInspectable
    var shadowBlur : CGFloat {

        get {
            return dialView.shadowBlur
        }

        set {
            dialView.shadowBlur = newValue
        }
    }


    // mark - Methods

    /**
    * Method to set the range of values to display
    */
    @objc(setDialRangeFrom:to:)
    func setDialRange(from: Int, to: Int) {

        min = from
        max = to

        dialView.setDialRange(from: from, to: to)
        scrollView.contentSize = CGSize(width: dialView.frame.size.width, height: bounds.size.height)
    }

    func scrollToOffset(starting: CGPoint) -> CGPoint {

        // Initialize the end point with the starting position
        var ending = starting

        // Calculate the ending offset
        ending.x = roundf(starting.x / CGFloat(minorTickDistance)) * CGFloat(minorTickDistance)

        println("starting=\(starting.x), ending=\(ending.x)")

        return ending
    }

}


extension DialScrollView : UIScrollViewDelegate {

    override func respondsToSelector(aSelector: Selector) -> Bool {

        if super.respondsToSelector(aSelector) {
            return true
        }

        if delegate?.respondsToSelector(aSelector) {
            return true
        }

        return false
    }

    override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject! {

        if delegate?.respondsToSelector(aSelector) {
            return delegate
        }

        return NSObject.forwardingTargetForSelector(aSelector)
    }

    func scrollViewWillEndDragging(scrollView: UIScrollView!,
        velocity: CGPoint,
        targetContentOffset: CMutablePointer<CGPoint>){

        targetContentOffset.withUnsafePointer { p in

            p.memory = self.scrollToOffset(p.memory)
        }

        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset:targetContentOffset)

    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        println("touchesBegan")
    }

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        println("touchesCancelled")
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)  {
        println("touchesEnded")
    }

    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)  {
        println("touchesMoved")
    }
}
