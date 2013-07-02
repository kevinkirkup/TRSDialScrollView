//
//  TRSDialScrollView.m
//  DialViewExample
//
//  Created by Kevin Kirkup on 7/1/13.
//  Copyright (c) 2013 TeaRoom Stdio. All rights reserved.
//

#import "TRSDialView.h"
#import "TRSDialScrollView.h"

@interface TRSDialScrollView () {
    
    NSInteger _currentValue;
}

@property (assign, nonatomic) NSInteger min;
@property (assign, nonatomic) NSInteger max;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *overlayImageView;
@property (strong, nonatomic) TRSDialView *dialView;

@end

@implementation TRSDialScrollView


- (void)commonInit
{
    _max = 0;
    _min = 0;
    
    float contentHeight = self.bounds.size.height;
    
    _overlayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
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
    
    [_scrollView addSubview:_dialView];
    [self addSubview:_scrollView];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
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
    self.overlayColor = overlayColor;
}

- (UIColor *)overlayColor
{
    return self.overlayColor;
}

- (void)setCurrentValue:(NSInteger)newValue {
    
    // Check to make sure the value is within the available range
    if ((newValue < _min) || (newValue > _max))
        _currentValue = 0;
    
    else
        _currentValue = newValue;
}

- (NSInteger)currentValue {
    return _currentValue;
}

@end
