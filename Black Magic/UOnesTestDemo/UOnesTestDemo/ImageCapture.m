//
//  Imagecapture.m
//  Testss
//
//  Created by 玉文辉 on 15/10/19.
//  Copyright © 2015年 yuwenhui. All rights reserved.
//

#import "ImageCapture.h"

@interface ImageCapture()
@property (strong, nonatomic) UIImage *image;
@end

@implementation ImageCapture

- (id)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)drawImage
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    CGPathMoveToPoint(path, NULL, origin.x + radius, origin.y);
    
    CGPathAddLineToPoint(path, NULL, origin.x + radius, origin.y + radius * 7 / 8);
    
    CGPathAddLineToPoint(path, NULL, origin.x + radius  * 5 / 4, origin.y + radius * 9 / 8);
    
    CGPathAddLineToPoint(path, NULL, origin.x + radius, origin.y + radius * 2);
    
    CGPathAddArcToPoint(path, NULL, origin.x + radius * 2, origin.y + radius * 2, origin.x + radius * 2, origin.y + radius, radius);
    
    CGPathAddArcToPoint(path, NULL, origin.x + radius * 2, origin.y, origin.x + radius, origin.y, radius);
    
    CAShapeLayer *maskLayer;
    maskLayer = [CAShapeLayer layer];
    maskLayer.path = path;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    maskLayer.frame = self.bounds;
    maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, origin.x + radius, origin.y);
    
    CGPathAddLineToPoint(path1, NULL, origin.x + radius, origin.y + radius * 7 / 8);
    
    CGPathAddLineToPoint(path1, NULL, origin.x + radius * 5 / 4, origin.y + radius * 9 / 8);
    
    CGPathAddLineToPoint(path1, NULL, origin.x + radius, origin.y + radius * 2);
    
    CGPathAddArcToPoint(path1, NULL, origin.x, origin.y + radius * 2, origin.x, origin.y + radius, radius);
    
    CGPathAddArcToPoint(path1, NULL, origin.x, origin.y, origin.x + radius, origin.y, radius);
    
    CAShapeLayer *maskLayer1;
    maskLayer1 = [CAShapeLayer layer];
    maskLayer1.path = path1;
    maskLayer1.fillColor = [UIColor blackColor].CGColor;
    maskLayer1.strokeColor = [UIColor clearColor].CGColor;
    maskLayer1.frame = self.bounds;
    maskLayer1.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer1.contentsScale = [UIScreen mainScreen].scale;
    
    
    CALayer *contentLayer = [CALayer layer];
    contentLayer.contents = (id)_image.CGImage;
    contentLayer.mask = maskLayer;
    contentLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    
    UIView *right = [[UIView alloc] init];
    [right.layer addSublayer:contentLayer];
    right.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    CATransform3D transform = CATransform3DIdentity;
    right.layer.anchorPoint = CGPointMake(0.5, 1);
    right.layer.position = CGPointMake(right.frame.size.width * 0.5, right.frame.size.height);
    NSLog(@"%f,%f",right.layer.position.x,right.layer.position.y);
    right.layer.sublayerTransform = CATransform3DRotate(transform, M_PI / 30, 0, 0, 1);
    [self addSubview:right];
    
    CALayer *contentLayer1 = [CALayer layer];
    contentLayer1.contents = (id)_image.CGImage;
    contentLayer1.mask = maskLayer1;
    contentLayer1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    
    UIView *left = [[UIView alloc] init];
    [left.layer addSublayer:contentLayer1];
    left.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    left.layer.anchorPoint = CGPointMake(0.5, 1);
    left.layer.position = CGPointMake(left.frame.size.width * 0.5, left.frame.size.height);
    left.layer.sublayerTransform = CATransform3DRotate(transform, -M_PI / 30, 0, 0, 1);
    [self addSubview:left];
    
    
}

//- (void)drawRect:(CGRect)rect
//{
//    CGFloat cutradius = self.bounds.size.width / 2 - 4;
//    CGRect Rect = CGRectMake(self.frame.origin.x + 2, self.frame.origin.y + 2, cutradius, cutradius);
//    CGContextRef contextcircle = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(contextcircle);
//    CGContextSetRGBStrokeColor(contextcircle, 0, 255, 0, 1);
//    CGContextMoveToPoint(contextcircle, CGRectGetMinX(Rect), CGRectGetMinY(Rect) + cutradius);
//    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - cutradius, CGRectGetMaxX(Rect) - cutradius, cutradius, M_PI, 3 * M_PI_2, 0);
//    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - cutradius, CGRectGetMaxX(Rect) - cutradius, cutradius, 3 * M_PI_2, 0, 0);
//    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - cutradius, CGRectGetMaxX(Rect) - cutradius, cutradius, 0, M_PI_2, 0);
//    CGContextAddArc(contextcircle, CGRectGetMaxX(Rect) - cutradius, CGRectGetMaxX(Rect) - cutradius, cutradius, M_PI_2, M_PI, 0);
//    CGContextStrokePath(contextcircle);
//}

@end
