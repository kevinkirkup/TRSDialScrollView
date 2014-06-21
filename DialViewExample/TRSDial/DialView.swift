/***************************************************
*  ____              ___   ____                   *
* |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
* | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
* |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
* |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
*                                                 *
***************************************************/
//
//  DialView.swift
//  DialViewExample
//
//  Created by Kevin Kirkup on 6/9/14.
//  Copyright (c) 2014 TeaRoom Stdio. All rights reserved.
//

import Foundation
import UIKit

let kTRSDialViewDefaultFont = "HelveticaNeue"
let kTRSDialViewDefaultLabelFontSize : CGFloat = 30
let kTRSDialViewDefaultMinorTickDistance : Int = 16
let kTRSDialViewDefaultMinorTickLength : CGFloat = 19.0
let kTRSDialViewDefaultMinorTickWidth : CGFloat =  1.0
let kTRSDialViewDefaultMajorTickDivisions : CGFloat = 10.0
let kTRSDialViewDefaultMajorTickLength : CGFloat = 31.0
let kTRSDialViewDefaultMajorTickWidth : CGFloat = 4.0

let kTRSDialViewDefaultStrokeWidth : CGFloat = 1.0

@IBDesignable
class DialView : UIView {

    // mark - Dial Properties

    /**
     * The leading to used for the dial text
     */
    var leading : Int = 0

    /**
    * The maximum value to display in the dial
    */
    var minimum : Int = 0

    /**
    * The minimum value to display in the dial
    */
    var maximum : Int = 0

    /**
    * The number of minor ticks per major tick
    */
    var minorTicksPerMajorTick : Int = Int(kTRSDialViewDefaultMajorTickDivisions)

    /**
    * The number of pixels/points between minor ticks
    */
    var minorTickDistance : Int = kTRSDialViewDefaultMinorTickDistance

    /**
    * The image to use as the background image
    */
    var dialBackgroundColor : UIColor = UIColor.grayColor()

    // mark - Tick Label Properties

    /**
    * The tick label stroke color
    */
    var labelStrokeColor : UIColor = UIColor(red:0.482, green:0.008, blue:0.027, alpha:1.000)

    /**
    * The width of the stroke line used to trace the Label text
    */
    var labelStrokeWidth : CGFloat = kTRSDialViewDefaultStrokeWidth

    /**
    * The tick label fill color
    */
    var labelFillColor : UIColor = UIColor.whiteColor()

    /**
    * The tick label font
    */
    var labelFont : UIFont = UIFont(name:kTRSDialViewDefaultFont, size:kTRSDialViewDefaultLabelFontSize)

    // mark - Minor Tick Properties

    /**
    * The minor tick color
    */
    var minorTickColor : UIColor = UIColor(white:0.158, alpha:1.000)

    /**
    * The length of the minor ticks
    */
    var minorTickLength : CGFloat = kTRSDialViewDefaultMinorTickLength

    /**
    * The length of the Major Tick
    */
    var minorTickWidth : CGFloat = kTRSDialViewDefaultMinorTickWidth

    // mark - Major Tick Properties

    /**
    * The color of the Major Tick
    */
    var majorTickColor : UIColor = UIColor(red:0.482, green:0.008, blue:0.027, alpha:1.000)

    /**
    * The length of the Major Tick
    */
    var majorTickLength : CGFloat = kTRSDialViewDefaultMajorTickLength

    /**
    * The width of the Major Tick
    */
    var majorTickWidth : CGFloat = kTRSDialViewDefaultMajorTickWidth

    // mark - Shadow Properties
    
    /**
    * The shadow color
    */
    var shadowColor : UIColor = UIColor(white: 1.000, alpha: 1.000)

    /**
    * The shadow offset
    */
    var shadowOffset : CGSize = CGSizeMake(1, 1)

    /**
    * The shadow blur radius
    */
    var shadowBlur : CGFloat = Float(0.9)

    init(frame: CGRect) {

        super.init(frame: frame)
        backgroundColor = self.dialBackgroundColor
    }

    init(coder aDecoder: NSCoder!) {

        super.init(coder: aDecoder)
        backgroundColor = self.dialBackgroundColor
    }

    /**
    * Method to set the range of values to display
    */
    func setDialRange(from from: Int, to: Int)
    {
        self.minimum = from;
        self.maximum = to;

        // Resize the frame of the view
        var frame = self.frame

        frame.size.width = (CGFloat(self.maximum) - CGFloat(self.minimum)) * CGFloat(self.minorTickDistance
            ) + self.superview.frame.size.width;

        println("frame = \(NSStringFromCGRect(frame))")

        self.frame = frame;

        self.setNeedsDisplay()

    }
    
}
