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
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

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


- (void)setup {
    self.centralView = nil;
    
    self.removeFromSuperViewOnHide = NO;

    // Make it invisible for now
    self.alpha = 0.0f;
    
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
    
    self.progressLayer = [CAShapeLayer layer];
    
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.strokeColor = self.progressTintColor.CGColor;
    _progressLayer.strokeEnd = 0;
    _progressLayer.fillColor = nil;
    [self.layer addSublayer:_progressLayer];
    
    self.gradientLayer = [CAGradientLayer layer];

    _gradientLayer.frame = self.bounds;
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:_gradientLayer];
}

#pragma mark Setters

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor
{
    _backgroundTintColor = backgroundTintColor;
    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    _progressLayer.strokeColor = _progressTintColor.CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = fmaxf(lineWidth, 1.f);
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressLayer.lineWidth = _lineWidth;
}

- (void)setProgressGradientColors:(NSArray *)progressGradientColors
{
    _gradientLayer.colors = progressGradientColors;
    _gradientLayer.mask = _progressLayer;
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
    
    // Draw inner circle
    CGContextSetFillColorWithColor(ctx, _innerCircleColor.CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + _lineWidth, rect.origin.y + _lineWidth,
                                                rect.size.width - (_lineWidth*2), rect.size.height - (_lineWidth*2)));
    CGContextFillPath(ctx);
    
    // Draw background
    [self drawBackgroundCircle];

    // Draw progress
    CGContextSetFillColorWithColor(ctx, self.progressTintColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.progressTintColor.CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, 1, 1));
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
            self.progressLayer.strokeEnd = progress;
            [self.progressLayer addAnimation:animation forKey:@"animation"];
            [CATransaction commit];
        }
        else
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.progressLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    }
    else
    {
        self.progressLayer.strokeEnd = 0.0f;
        [self.progressLayer removeAnimationForKey:@"animation"];
    }
    _progress = progress;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    self.gradientLayer.frame = self.bounds;
    self.progressLayer.frame = self.bounds;
    self.centralView.center = center;
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:-M_PI_2 + (2 * M_PI) clockwise:YES].CGPath;
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
