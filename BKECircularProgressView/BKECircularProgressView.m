//
//  BKECircularProgressView.m
//  kickit
//
//  Created by Brian Kenny on 22/01/2014.
//  Copyright (c) 2014 Brian Kenny. All rights reserved.
//

#import "BKECircularProgressView.h"

@interface BKECircularProgressView()

@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CALayer *baseLayer;

@end

@implementation BKECircularProgressView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.centralView = nil;
    self.baseLayer = nil;
    
    self.removeFromSuperViewOnHide = NO;
    
    self.backgroundColor = [UIColor clearColor];
    _innerCircleColor = [UIColor clearColor];
    
    _progress = 0.0f;
    
    _lineWidth = fmaxf(self.frame.size.width * 0.025, 1.f);
    _progressTintColor = [UIColor redColor];
    _backgroundTintColor = [UIColor blueColor];
    
    self.progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressBackgroundLayer];
    
    self.maskLayer = [CAShapeLayer layer];
    
    _maskLayer.lineWidth = _lineWidth;
    _maskLayer.strokeColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeEnd = 0;
    _maskLayer.fillColor = nil;
}

#pragma mark Setters

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor
{
    _backgroundTintColor = backgroundTintColor;
    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if(self.baseLayer)
    {
        [_baseLayer removeFromSuperlayer];
    }
    
    CALayer *solidLayer = [CALayer layer];
    
    _progressTintColor = progressTintColor;
    solidLayer.frame = self.bounds;
    solidLayer.backgroundColor = _progressTintColor.CGColor;
    solidLayer.mask = _maskLayer;
    
    self.baseLayer = solidLayer;
    
    [self.layer addSublayer:solidLayer];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = fmaxf(lineWidth, 1.f);
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _maskLayer.lineWidth = _lineWidth;
}

- (void)setProgressGradientColors:(NSArray *)progressGradientColors
{
    if(self.baseLayer)
    {
        [_baseLayer removeFromSuperlayer];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.colors = progressGradientColors;
    gradientLayer.mask = _maskLayer;
    
    self.baseLayer = gradientLayer;
    
    [self.layer addSublayer:gradientLayer];
}

- (void)setCentralView:(UIView *)centralView
{
    if (_centralView != centralView)
    {
        [_centralView removeFromSuperview];
        _centralView = centralView;
        [self addSubview:self.centralView];
    }
}

- (void)setInnerCircleColor:(UIColor *)innerCircleColor
{
    _innerCircleColor = innerCircleColor;
    [self setNeedsDisplay];
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw background
    [self drawBackgroundCircle];
    
    // Draw inner circle
    CGContextSetFillColorWithColor(ctx, _innerCircleColor.CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + _lineWidth-1, rect.origin.y + _lineWidth-1,
                                                rect.size.width - (_lineWidth*2)+2, rect.size.height - (_lineWidth*2)+2));
    CGContextFillPath(ctx);
    
    // Draw progress
    [self drawProgressCircle];
}

- (void)drawBackgroundCircle
{
    CGFloat startAngle = -M_PI_2; // 90 degrees
    CGFloat endAngle = startAngle + (2 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}

- (void)drawProgressCircle
{
    CGFloat startAngle = -M_PI_2; // 90 degrees
    CGFloat endAngle = -M_PI_2 + (2 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;

    // Draw progress
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineWidth = _lineWidth;
    processPath.lineCapStyle = kCGLineCapButt;
    
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _maskLayer.path = processPath.CGPath;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (progress > 1.0f) progress = 1.0f;
    if (progress > 0)
    {
        if (animated)
        {
            [CATransaction begin];
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(self.progress);
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            self.maskLayer.strokeEnd = progress;
            [self.maskLayer addAnimation:animation forKey:@"animation"];
            [CATransaction commit];
        }
        else
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.maskLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    }
    else
    {
        self.maskLayer.strokeEnd = 0.0f;
        [self.maskLayer removeAnimationForKey:@"animation"];
    }
    _progress = progress;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.maskLayer.frame = self.bounds;
    self.centralView.center = center;
}

#pragma mark - Visibility

- (instancetype)BKEProgressForView:(UIView *)view
{
	NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum)
    {
		if ([subview isKindOfClass:[BKECircularProgressView class]])
        {
			return (BKECircularProgressView *)subview;
		}
	}
	return nil;
}

- (BOOL)hideBKEProgressForView:(UIView *)view
{
	BKECircularProgressView *progressView = [self BKEProgressForView:view];
	if (progressView != nil)
    {
		progressView.removeFromSuperViewOnHide = YES;
		[progressView hide];
		return YES;
	}
	return NO;
}

- (void)hide
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.alpha = 0.0f;
	if (self.removeFromSuperViewOnHide)
    {
		[self removeFromSuperview];
	}
}

- (void)show
{
    self.alpha = 1.0f;
}

@end
