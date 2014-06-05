/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "CoreText/CoreText.h"

#import "TRSDialView.h"

NSString * const kTRSDialViewDefaultFont = @"HelveticaNeue";

const NSInteger kTRSDialViewDefautLabelFontSize = 30;

const CGFloat kTRSDialViewDefaultMinorTickDistance = 16.0f;
const CGFloat kTRSDialViewDefaultMinorTickLength   = 19.0f;
const CGFloat KTRSDialViewDefaultMinorTickWidth    =  1.0f;

const NSInteger kTRSDialViewDefaultMajorTickDivisions = 10;
const CGFloat kTRSDialViewDefaultMajorTickLength      = 31.0f;
const CGFloat kTRSDialViewDefaultMajorTickWidth       = 4.0f;


@interface TRSDialView ()

@end

@implementation TRSDialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _minimum = 0;
        _maximum = 0;

        _minorTicksPerMajorTick = kTRSDialViewDefaultMajorTickDivisions;
        _minorTickDistance = kTRSDialViewDefaultMinorTickDistance;

        _backgroundColor = [UIColor grayColor];

        _labelStrokeColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _labelFillColor = [UIColor whiteColor];
        _labelStrokeWidth = 1.0;

        _labelFont = [UIFont fontWithName:kTRSDialViewDefaultFont
                                     size:kTRSDialViewDefautLabelFontSize];

        _minorTickColor = [UIColor colorWithWhite:0.158 alpha:1.000];
        _minorTickLength = kTRSDialViewDefaultMinorTickLength;
        _minorTickWidth = KTRSDialViewDefaultMinorTickWidth;

        _majorTickColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _majorTickLength = kTRSDialViewDefaultMajorTickLength;
        _majorTickWidth = kTRSDialViewDefaultMajorTickWidth;

        _shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _shadowOffset = CGSizeMake(1, 1);
        _shadowBlur = 0.9f;

    }

    return self;
}

- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to {

    _minimum = from;
    _maximum = to;
    
    // Resize the frame of the view
    CGRect frame = self.frame;
    
    frame.size.width = (_maximum - _minimum) * _minorTickDistance + self.superview.frame.size.width;
    
    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    
    self.frame = frame;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawLabelWithContext:(CGContextRef)context
                     atPoint:(CGPoint)point
                        text:(NSString *)text
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor {
    
    CGSize boundingBox = [text sizeWithAttributes:@{NSFontAttributeName:self.labelFont}];
    
    CGFloat label_y_offset = self.majorTickLength + (boundingBox.height / 2);

    // We want the label to be centered on the specified x value
    NSInteger label_x = point.x - (boundingBox.width / 2);

    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGContextSetLineWidth(context, self.labelStrokeWidth);
    
    // Set the drawing mode based on the presence of the file and stroke colors
    CGTextDrawingMode mode = kCGTextFillStroke;
    
    if ((fillColor == nil) && (strokeColor == nil))
        mode = kCGTextInvisible;
        
    else if (fillColor == nil)
        mode = kCGTextStroke;
    
    else if (strokeColor == nil)
        mode = kCGTextFill;
    
    CGContextSetTextDrawingMode(context, mode);

    // The center position
    CGRect textRect = CGRectMake(label_x, point.y + label_y_offset, boundingBox.width, boundingBox.height);

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    [style setAlignment:NSTextAlignmentCenter];

    NSDictionary *attributes = @{
                                 NSStrokeWidthAttributeName : @(-self.labelStrokeWidth),
                                 NSFontAttributeName : self.labelFont,
                                 NSForegroundColorAttributeName : fillColor,
                                 NSStrokeColorAttributeName : strokeColor
                                 };


    [text drawInRect:textRect
      withAttributes:attributes];


}

- (void)drawMinorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length {

    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);

    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y + length);

    CGContextStrokePath(context);
}

- (void)drawMajorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length {

    // Draw the line
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSetLineCap(context, kCGLineCapRound);

    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y + length);

    CGContextStrokePath(context);

}

- (void)drawTicksWithContext:(CGContextRef)context atX:(long)x
{

    CGPoint point = CGPointMake(x, 0);
    CGContextSetShadowWithColor(
        context,
        self.shadowOffset,
        self.shadowBlur,
        self.shadowColor.CGColor);

    if ([self isMajorTick:x]) {

        [self drawMajorTickWithContext:context
                               atPoint:point
                             withColor:self.majorTickColor
                                 width:self.majorTickWidth
                                length:self.majorTickLength];

        // Draw the text
        //
        // 1) Take the existing position and subtract off the lead spacing
        // 2) Divide by the minor ticks to get the major number
        // 3) Add the minimum to get the current value
        //
        int value = (point.x - self.leading) / self.minorTickDistance + _minimum;

        NSString *text = [NSString stringWithFormat:@"%i", value];
        [self drawLabelWithContext:context
                           atPoint:point
                              text:text
                         fillColor:self.labelFillColor
                       strokeColor:self.labelStrokeColor];

    } else {

        // Save the current context so we revert some of the changes laster
        CGContextSaveGState(context);

        [self drawMinorTickWithContext:context
                               atPoint:point
                             withColor:self.minorTickColor
                                 width:self.minorTickWidth
                                length:self.minorTickLength];

        // Restore the context
        CGContextRestoreGState(context);
    }
}

/**
 * The number of pixels that need to be prepended to the begining and ending
 * of the dial to make sure that the center mark is able to reach all available
 * values on the range of the dial.
 */
- (NSInteger)leading
{
    return self.superview.frame.size.width / 2;
}

/**
 * Perform Custom drawing
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"frame = %@\n", NSStringFromCGRect(rect));

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill the background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);

    CGContextFillRect(context, rect);
    
    // Add the tick Marks
    for (long i = self.leading; i < rect.size.width; i += self.minorTickDistance) {

        // After
        if (i > (self.frame.size.width - self.leading))
            break;

        // Middle
        else
            [self drawTicksWithContext:context atX:i];

    }
}

/**
 * Method to check if there is a major tick and the specified point offset
 * @param x [in] the pixel offset
 */
- (BOOL)isMajorTick:(long)x {

    long tick_number = (x - self.leading) / self.minorTickDistance;

    return (tick_number % self.minorTicksPerMajorTick) == 0;
}

@end

