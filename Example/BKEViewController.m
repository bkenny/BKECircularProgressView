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
    
    [self displayProgressView];
    [self showProgress];
}

-(void)displayProgressView {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
	[label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:14];
    
    _progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    [_progressView setProgressTintColor:[UIColor colorWithRed:224.0/255.0 green:80.0/255.0 blue:15.0/255.0 alpha:1]];
    [_progressView setBackgroundTintColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]];
    [_progressView setCentralView:label];
    [_progressView setLineWidth:3.0f];
    [self.view addSubview:_progressView];
}

-(void)showProgress {
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        for (float i=0; i<1.0; i+=0.01F) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_progressView setProgress:i];
                [(UILabel *)_progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", i * 100]];
            });
            usleep(10000);
        }
    });
}

@end
