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

@interface TRSViewController ()  <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;

@end

@implementation TRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:16];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialBackground"]]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
    [_dialView setDialRangeFrom:0 to:50];
    
    _dialView.currentValue = 10;

    _dialView.delegate = self;
    
    NSLog(@"Current Value = %li", (long)_dialView.currentValue);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    NSLog(@"scrollViewDidEndDecelerating: %li", (long)_dialView.currentValue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging: %li", (long)_dialView.currentValue);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    static NSInteger last_value = 0;

    // Calculate the value based on the content offset
    NSInteger value = self.dialView.currentValue;

    if (value != last_value) {
        NSLog(@"Metric: value=%li", (long)value);
    }
    
    last_value = value;
}


@end
