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

@end

@implementation BKECircularProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
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
    [self.layer addSublayer:_progressLayer];
}

#pragma mark Setters

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor {
    _backgroundTintColor = backgroundTintColor;
    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    _progressLayer.strokeColor = _progressTintColor.CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = fmaxf(lineWidth, 1.f);
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressLayer.lineWidth = _lineWidth;
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    [self drawBackgroundCircle];
    
    // Draw progress
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    // CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = _lineWidth;
    
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [_progressLayer setPath:processPath.CGPath];
}

- (void) drawBackgroundCircle {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        
        [self setNeedsDisplay];
    }
}

@end
