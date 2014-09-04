//
//  BKECircularProgressView.h
//  kickit
//
//  Created by Brian Kenny on 22/01/2014.
//  Copyright (c) 2014 Brian Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BKECircularProgressView : UIView

/**
 * initWithFrame using gradient progress.
 **/
- (id)initWithFrame:(CGRect)frame andUseGradientProgress:(BOOL)gradientProgress;

/**
 * initWithCoder using gradient progress.
 **/
- (id)initWithCoder:(NSCoder *)aDecoder andUseGradientProgress:(BOOL)gradientProgress;

/**
 * The progress of the view.
 **/
@property (nonatomic, assign) CGFloat progress;

/**
 * The width of the line used to draw the progress view.
 **/
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * The color of the progress view
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * The color of the background of the progress view
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/**
 * The colors gradient of the progress view
 */
@property (nonatomic, strong) NSArray *progressGradientColors;

@end
