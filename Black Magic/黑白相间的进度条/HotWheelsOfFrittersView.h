//
//  HotWheelsOfFrittersView.h
//  Test
//
//  Created by 玉文辉 on 15/8/14.
//  Copyright (c) 2015年 玉文辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotWheelsDelegate

@required

- (UIColor *)setbackcolor;
- (UIColor *)setwheelcolor;

@end

@interface HotWheelsOfFrittersView : UIView
@property (strong, nonatomic) id<HotWheelsDelegate> delegate;
@property (nonatomic) CGFloat interval; //转速
@property (nonatomic) CGFloat backAlpha; //背景透明
- (void)start; 
- (void)stop;
@end
