//
//  HotWheelsOfFrittersView.h
//  Test
//
//  Created by 玉文辉 on 15/8/14.
//  Copyright (c) 2015年 玉文辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgress : UIView
@property (nonatomic) CGFloat interval; //转速
- (void)start:(CGFloat)stoke;
- (void)stop;
@end
