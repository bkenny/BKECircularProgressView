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

/*
 * The colors gradient of the progress view
 */
@property (nonatomic, strong) NSArray *progressGradientColors;

/*
 * The color inner circle
 */
@property (nonatomic, strong) UIColor *innerCircleColor;

 /*
 *  The view in the center of the progress view.
 *
 *  Can be set to anything you want though, a label with the progress, a stop button etc.
 *
 *  Defaults to nil.
 */
@property (nonatomic, strong) UIView *centralView;

@end
