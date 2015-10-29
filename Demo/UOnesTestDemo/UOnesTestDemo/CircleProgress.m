//
//  HotWheelsOfFrittersView.m
//  Test
//
//  Created by 玉文辉 on 15/8/14.
//  Copyright (c) 2015年 玉文辉. All rights reserved.
//

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0)
#define PartNumber      240

#import "CircleProgress.h"

@interface CircleProgress()
@property (nonatomic) NSInteger cyclenum;
@property (nonatomic) CGContextRef contextline;
@property (nonatomic) CGContextRef context;
@property (nonatomic) NSTimer *time;
@property (nonatomic) NSInteger gostoke;
@property (nonatomic) CAShapeLayer *cashapelayer;
@property (nonatomic,strong) UIView *cirview;
@end

@implementation CircleProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setback];
    }
    return self;
}

- (void)setback
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [self setCircle];
    _cyclenum = 1;
    float width = (float) 1 / PartNumber;
    [self setLineAlphaStartStorke:0 EndStroke:width Color:[UIColor blackColor]];
    for (int i = 0; i < PartNumber; i ++) {
        if (i % 2 ==0) {
            [self setLineAlphaStartStorke:i * width EndStroke:width + i * width Color:[UIColor grayColor]];
        }
    }
}

- (void)animationofwheel:(NSTimer *)time
{
    _cyclenum++;
    float width = (float) 1 / PartNumber;
    if (_cyclenum % 2 == 0) {
        [self setLineAlphaStartStorke:_cyclenum * width EndStroke:_cyclenum * width + width Color:[UIColor blackColor]];
        _cirview.center = [self pointFromAngle:(float)_cyclenum/PartNumber*360];
    }
    if (_cyclenum > _gostoke) {
        [_time invalidate];
    }
}

-(CGPoint)pointFromAngle:(float)angleInt{
    CGFloat radius = self.bounds.size.width / 2 - 3;
    CGPoint centerPoint = CGPointMake(radius + 3, radius + 3);
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt) - ToRad(89)));
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt) - ToRad(89)));
    return result;
}

- (void)start:(CGFloat)stoke
{
    if (!_interval) {
        _interval = 0.05;
    }
    _gostoke =  stoke * PartNumber;
    _time = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(animationofwheel:) userInfo:nil repeats:YES];
}

- (void)stop
{
    [_time invalidate];
}

- (void)setCircle
{
    _context = UIGraphicsGetCurrentContext();
    CGFloat radius = self.bounds.size.width / 2 - 3;
//    CGRect Rect = self.bounds;
    CGRect Rect = CGRectMake(3, 3, self.bounds.size.width - 6, self.bounds.size.height - 6);
    
    CGContextRef contextcircle = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextcircle);
    CGContextSetLineWidth(contextcircle, 1);
    CGContextSetRGBStrokeColor(contextcircle, 0, 255, 0, 1);
    CGContextMoveToPoint(contextcircle, CGRectGetMinX(Rect), CGRectGetMinY(Rect) + radius);
    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - radius, CGRectGetMaxX(Rect) - radius, radius, M_PI, 3 * M_PI_2, 0);
    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - radius, CGRectGetMaxX(Rect) - radius, radius, 3 * M_PI_2, 0, 0);
    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - radius, CGRectGetMaxX(Rect) - radius, radius, 0, M_PI_2, 0);
    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - radius, CGRectGetMaxX(Rect) - radius, radius, M_PI_2, M_PI, 0);
    CGContextStrokePath(contextcircle);
    
    _cirview = [[UIView alloc] initWithFrame:CGRectMake(radius, 0, 6, 6)];
    _cirview.layer.cornerRadius = 3;
    _cirview.backgroundColor = [UIColor greenColor];
    [self addSubview:_cirview];
}

- (void)setLineAlphaStartStorke:(CGFloat)start EndStroke:(CGFloat)end Color:(UIColor *)color
{
    CGFloat radius = self.bounds.size.width / 2;
    
    _cashapelayer = [self createRingLayerWithCenter:CGPointMake(radius, radius) radius:radius * 7 / 8 - 2 lineWidth:radius / 8 color:color];
    _cashapelayer.strokeStart = start;
    _cashapelayer.strokeEnd = end;
    [self.layer addSublayer:_cashapelayer];
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
