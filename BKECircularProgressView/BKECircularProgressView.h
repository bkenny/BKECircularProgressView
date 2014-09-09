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
 * The progress of the view. Only valid for values between `0` and `1`.
 **/
@property (nonatomic, assign) CGFloat progress;

/**
 Set the progress of the circular view in an animated manner. Only valid for values between `0` and `1`.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

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

/**
 * The color inner circle
 */
@property (nonatomic, strong) UIColor *innerCircleColor;

/**
 *  The view in the center of the progress view.
 *
 *  Can be set to anything you want though, a label with the progress, a stop button etc.
 *
 *  Defaults to nil.
 */
@property (nonatomic, strong) UIView *centralView;

/**
 * Removes the progress of the view from its parent view when hidden.
 * Defaults to NO.
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/**
 * Display the BKECircularProgressView. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 */
- (void)show;

/**
 * Hide the BKECircularProgressView. This is the counterpart of the show: method. Use it to
 * hide the BKECircularProgressView when your task completes.
 */
- (void)hide;

@end
