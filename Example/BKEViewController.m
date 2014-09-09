//
//  BKEViewController.m
//  BKECircularProgressView
//
//  Created by Brian Kenny on 24/01/2014.
//  Copyright (c) 2014 Brian Kenny. All rights reserved.
//

#import "BKEViewController.h"
#import "BKECircularProgressView.h"

@interface BKEViewController ()

@property (strong) BKECircularProgressView *progressView;

@end

@implementation BKEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupProgressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupProgressView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
	[label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:14];
    
    _progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    [_progressView setProgressTintColor:[UIColor colorWithRed:224.0/255.0 green:80.0/255.0 blue:15.0/255.0 alpha:1]];
    [_progressView setBackgroundTintColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]];
    [_progressView setCentralView:label];
    [_progressView setLineWidth:3.0f];
    [_progressView setAlpha:1.0f];
    [self.view addSubview:_progressView];
}

- (IBAction)toggleInnerCircle:(id)sender
{
    UISwitch *innerCircleSwitch = (UISwitch *) sender;
    if(innerCircleSwitch.on)
    {
        [_progressView setInnerCircleColor:[UIColor colorWithRed:243.0/255.0 green:144.0/255.0 blue:52.0/255.0 alpha:1]];
    }
    else
    {
        [_progressView setInnerCircleColor:[UIColor clearColor]];
    }
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        [_progressView setProgressTintColor:[UIColor colorWithRed:224.0/255.0 green:80.0/255.0 blue:15.0/255.0 alpha:1]];
    }
    else
    {
        [_progressView setProgressGradientColors:@[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor]];
    }
}

- (IBAction)btnAnimateTouched:(id)sender
{
    CGFloat progress = self.sliderProgress.value;
    
    [_progressView setProgress:progress animated:YES];
    [(UILabel *)_progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
}


- (IBAction)btnShowTouched:(id)sender
{
    [_progressView show];
}

- (IBAction)btnHideTouched:(id)sender
{
    [_progressView hide];
}

@end
