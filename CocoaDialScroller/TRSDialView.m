/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialView.h"

#define MIN_DIAL_WIDTH  (320.0)
#define DIAL_HEIGHT     (80.0)



#define LABEL_FONT_SIZE (30)

#define MINOR_TICK_DISTANCE  (16)
#define MINOR_TICK_LENGTH    (19)
#define MINOR_TICK_WIDTH     (1.0)

#define MAJOR_TICK_DIVISIONS  (10)
#define MAJOR_TICK_LENGTH     (31)
#define MAJOR_TICK_WIDTH      (4.0)


@interface TRSDialView ()

@property (readonly, nonatomic) CGFloat labelHeight;
@property (readonly, nonatomic) CGFloat labelWidth;
@property (readonly, nonatomic) CGFloat lableYOffset;

/**
 * Method to set the range of values to display
 */
- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to;

@end

@implementation TRSDialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _minimum = 0;
        _maximum = 0;

        _minorTicksPerMajorTick = MAJOR_TICK_DIVISIONS;
        _minorTickDistance = MINOR_TICK_DISTANCE;

        _backgroundColor = [UIColor grayColor];

        _labelStrokeColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _labelFillColor = [UIColor whiteColor];

        _labelFont = [UIFont fontWithName:@"HelveticaNeue" size:LABEL_FONT_SIZE];

        _minorTickColor = [UIColor colorWithWhite:0.158 alpha:1.000];
        _minorTickLength = MINOR_TICK_LENGTH;
        _minorTickWidth = MINOR_TICK_WIDTH;

        _majorTickColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _majorTickLength = MAJOR_TICK_LENGTH;
        _majorTickWidth = MAJOR_TICK_WIDTH;

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
    
    frame.size.width = (_maximum - _minimum) * _minorTickDistance + MIN_DIAL_WIDTH;
    
    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    
    self.frame = frame;
}

- (CGFloat)labelHeight
{
    return 20;
}

- (CGFloat)labelYOffset
{
    return (self.majorTickLength + (self.labelHeight / 2));
}

- (CGFloat)labelWidth
{
    return 60;
}

#pragma mark - Drawing

- (void)drawLabelWithContext:(CGContextRef)context
                     atPoint:(CGPoint)point
                        text:(NSString *)text
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor {

    // We want the label to be centered on the specified x value
    NSInteger label_x = point.x - (self.labelWidth / 2);

    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGContextSetLineWidth(context, 1.0);
    CGContextSetTextDrawingMode(context, kCGTextFill);

    [text drawInRect:CGRectMake(label_x, point.y + self.labelYOffset, self.labelWidth, self.labelHeight)
            withFont:self.labelFont
       lineBreakMode:NSLineBreakByTruncatingTail
           alignment:NSTextAlignmentCenter];

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


- (void)drawDisabledTicksWithContext:(CGContextRef)context atX:(int)x
{
    CGPoint point = CGPointMake(x, 0);

    if ([self isMajorTick:x])
        [self drawMajorTickWithContext:context
                               atPoint:point
                             withColor:[UIColor clearColor]
                                 width:self.majorTickWidth
                                length:self.majorTickLength];

    else
        [self drawMinorTickWithContext:context
                               atPoint:point
                             withColor:[UIColor clearColor]
                                 width:self.minorTickWidth
                                length:self.minorTickLength];
}

- (void)drawRegularTicksWithContext:(CGContextRef)context atX:(int)x
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
        int value = (point.x - (MIN_DIAL_WIDTH / 2)) / self.minorTickDistance + _minimum;

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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //NSLog(@"frame = %@\n", NSStringFromCGRect(rect));
    
    NSLog(@"frame = %@\n", NSStringFromCGRect(self.frame));

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill the background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);

    CGContextFillRect(context, rect);

    // Add the tick Marks
    for (int i = 0; i < rect.size.width; i += self.minorTickDistance) {

        // The first two sets need to be disabled
        if ((i < (self.superview.frame.size.width / 2)) ||
            (i > (self.frame.size.width - (self.superview.frame.size.width / 2))))

            [self drawDisabledTicksWithContext:context atX:i];


        // Draw regular ticks
        else
            [self drawRegularTicksWithContext:context atX:i];

    }
}

/**
 * Method to check if there is a major tick and the specified point offset
 * @param x [in] the pixel offset
 */
- (BOOL)isMajorTick:(int)x {

    int tick_number = x / self.minorTickDistance;

    return (tick_number % self.minorTicksPerMajorTick) == 0;
}

@end

