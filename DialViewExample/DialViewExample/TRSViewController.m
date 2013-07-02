/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialScrollView.h"
#import "TRSViewController.h"

@interface TRSViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;

@end

@implementation TRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:16];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor whiteColor]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithWhite:0.0 alpha:1.000]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithWhite:0.700 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(1, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
    [_dialView setDialRangeFrom:0 to:50];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (CGPoint)scrollToOffset:(CGPoint)starting {
    
    // Initialize the end point with the starting position
    CGPoint ending = starting;
    
    // Calculate the ending offset
    ending.x = roundf(starting.x / 15.0) * 15.0;
    
    NSLog(@"starting=%f, ending=%f", starting.x, ending.x);
    
    return ending;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    *targetContentOffset = [self scrollToOffset:(*targetContentOffset)];
}

@end
