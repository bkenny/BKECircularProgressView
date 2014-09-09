//
//  BKEViewController.h
//  BKECircularProgressView
//
//  Created by Brian Kenny on 24/01/2014.
//  Copyright (c) 2014 Brian Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKEViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnShow;
@property (strong, nonatomic) IBOutlet UIButton *btnHide;
@property (strong, nonatomic) IBOutlet UIButton *btnAnimate;
@property (strong, nonatomic) IBOutlet UISwitch *switchInnerCircle;
@property (strong, nonatomic) IBOutlet UISlider *sliderProgress;

- (IBAction)btnShowTouched:(id)sender;
- (IBAction)btnHideTouched:(id)sender;
- (IBAction)btnAnimateTouched:(id)sender;
- (IBAction)toggleInnerCircle:(id)sender;

@end
