/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialView.h"
#import "TRSDialScrollView.h"

@interface TRSDialScrollView () <UIScrollViewDelegate> {
    
    NSInteger _currentValue;
}

@property (assign, nonatomic) NSInteger min;
@property (assign, nonatomic) NSInteger max;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) TRSDialView *dialView;

@end

@implementation TRSDialScrollView


- (void)commonInit
{
    _max = 0;
    _min = 0;
    
    float contentHeight = self.bounds.size.height;
    
    _overlayView = [[UIView alloc] initWithFrame:self.bounds];
    [_overlayView setUserInteractionEnabled:NO];
    
    // Set the default frame size
    // Don't worry, we will be changing this later
    _dialView = [[TRSDialView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, contentHeight)];
    
    // Don't let the container handle User Interaction
    [_dialView setUserInteractionEnabled:NO];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    // Disable scroll bars
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setClipsToBounds:YES];
    _scrollView.contentSize = CGSizeMake(_dialView.frame.size.width, contentHeight);
    
    
    // Setup the ScrollView
    [_scrollView setBounces:NO];
    [_scrollView setBouncesZoom:NO];
    _scrollView.delegate = self;
    
    [_scrollView addSubview:_dialView];
    [self addSubview:_scrollView];
    [self addSubview:_overlayView];
    
    // Clips the Dial View to the bounds of this view
    self.clipsToBounds = YES;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {

        [self commonInit];
    }
    
    return self;
}

#pragma mark - Methods

- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to {
    
    self.min = from;
    self.max = to;
    
    // Update the dial view
    [self.dialView setDialRangeFrom:from to:to];

    self.scrollView.contentSize = CGSizeMake(self.dialView.frame.size.width, self.bounds.size.height);
}

- (CGPoint)scrollToOffset:(CGPoint)starting {
    
    // Initialize the end point with the starting position
    CGPoint ending = starting;
    
    // Calculate the ending offset
    ending.x = roundf(starting.x / self.minorTickDistance) * self.minorTickDistance;
    
    NSLog(@"starting=%f, ending=%f", starting.x, ending.x);
    
    return ending;
}

#pragma mark - UIScrollViewDelegate

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    
    if ([self.delegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector])
        return self.delegate;

    // Always call parent object for default
    return [super forwardingTargetForSelector:aSelector];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Make sure that we scroll to the nearest tick mark on the dial.
    *targetContentOffset = [self scrollToOffset:(*targetContentOffset)];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        
        [self.delegate scrollViewWillEndDragging:scrollView
                                    withVelocity:velocity
                             targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:scrollView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchBegan");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
}

#pragma mark - Properties

- (void)setMinorTicksPerMajorTick:(NSInteger)minorTicksPerMajorTick
{
    self.dialView.minorTicksPerMajorTick = minorTicksPerMajorTick;
}

- (NSInteger)minorTicksPerMajorTick
{
    return self.dialView.minorTicksPerMajorTick;
}

- (void)setMinorTickDistance:(NSInteger)minorTickDistance
{
    self.dialView.minorTickDistance = minorTickDistance;
}

- (NSInteger)minorTickDistance
{
    return self.dialView.minorTickDistance;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.dialView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor
{
    return self.dialView.backgroundColor;
}

- (void)setLabelStrokeColor:(UIColor *)labelStrokeColor
{
    self.dialView.labelStrokeColor = labelStrokeColor;
}

- (UIColor *)labelStrokeColor
{
    return self.dialView.labelStrokeColor;
}

- (void)setLabelFillColor:(UIColor *)labelFillColor
{
    self.dialView.labelFillColor = labelFillColor;
}

- (void)setLabelStrokeWidth:(CGFloat)labelStrokeWidth
{
    self.dialView.labelStrokeWidth = labelStrokeWidth;
}

- (CGFloat)labelStrokeWidth
{
    return self.dialView.labelStrokeWidth;
}

- (UIColor *)labelFillColor
{
    return self.dialView.labelFillColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    self.dialView.labelFont = labelFont;
}

- (UIFont *)labelFont
{
    return self.dialView.labelFont;
}

- (void)setMinorTickColor:(UIColor *)minorTickColor
{
    self.dialView.minorTickColor = minorTickColor;
}

- (UIColor *)minorTickColor
{
    return self.dialView.minorTickColor;
}

- (void)setMinorTickLength:(CGFloat)minorTickLength
{
    self.dialView.minorTickLength = minorTickLength;
}

- (CGFloat)minorTickLength
{
    return self.dialView.minorTickLength;
}

- (void)setMinorTickWidth:(CGFloat)minorTickWidth
{
    self.dialView.minorTickWidth = minorTickWidth;
}

- (CGFloat)minorTickWidth
{
    return self.dialView.minorTickWidth;
}

- (void)setMajorTickColor:(UIColor *)majorTickColor
{
    self.dialView.majorTickColor = majorTickColor;
}

- (UIColor *)majorTickColor
{
    return self.dialView.majorTickColor;
}

- (void)setMajorTickLength:(CGFloat)majorTickLength
{
    self.dialView.majorTickLength = majorTickLength;
}

- (CGFloat)majorTickLength
{
    return self.dialView.majorTickLength;
}

- (void)setMajorTickWidth:(CGFloat)majorTickWidth
{
    self.dialView.majorTickWidth = majorTickWidth;
}

- (CGFloat)majorTickWidth
{
    return self.dialView.majorTickWidth;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.dialView.shadowColor = shadowColor;
}

- (UIColor *)shadowColor
{
    return self.dialView.shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.dialView.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset
{
    return self.dialView.shadowOffset;
}

- (void)setShadowBlur:(CGFloat)shadowBlur
{
    self.dialView.shadowBlur = shadowBlur;
}

- (CGFloat)shadowBlur
{
    return self.dialView.shadowBlur;
}

- (void)setOverlayColor:(UIColor *)overlayColor
{
    self.overlayView.backgroundColor = overlayColor;
}

- (UIColor *)overlayColor
{
    return self.overlayColor;
}

- (void)setCurrentValue:(NSInteger)newValue {
    
    // Check to make sure the value is within the available range
    if ((newValue < _min) || (newValue > _max))
        _currentValue = _min;
    
    else
        _currentValue = newValue;
    
    // Update the content offset based on new value
    CGPoint offset = self.scrollView.contentOffset;

    offset.x = (newValue - self.dialView.minimum) * self.dialView.minorTickDistance;
    
    self.scrollView.contentOffset = offset;
}

- (NSInteger)currentValue
{
    return roundf(self.scrollView.contentOffset.x / self.dialView.minorTickDistance) + self.dialView.minimum;
}

@end
