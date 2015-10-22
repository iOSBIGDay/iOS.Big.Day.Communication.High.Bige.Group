//
//  TJNavigationControllerShouldPopProtocol.h
//  TJRiseTabBarDemo
//
//  Created by tofu on 8/12/15.
//  Copyright (c) 2015 tofujelly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJNavigationController;

@protocol YYNavigationControllerShouldPopProtocol <NSObject>

@optional
-(BOOL)yy_navagationControllerShouldPopWhenSystemBackItemClick:(TJNavigationController *)navigationController;

@end
