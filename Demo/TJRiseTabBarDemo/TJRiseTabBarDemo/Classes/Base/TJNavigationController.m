//
//  TJNavigationController.m
//  TJRiseTabBarDemo
//
//  Created by tofu on 15/10/20.
//  Copyright © 2015年 Tofu Jelly. All rights reserved.
//

#import "TJNavigationController.h"
#import "YYNavigationControllerShouldPopProtocol.h"


@interface UINavigationController (UINavigationControllerNeedPop)

-(BOOL)navigationBar:(UINavigationBar *)navigationBar
       shouldPopItem:(UINavigationItem *)item;

@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincomplete-implementation"
@implementation UINavigationController (UINavigationControllerNeedPop)
@end
#pragma clang diagnostic pop

@interface TJNavigationController ()

@end

@implementation TJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)navigationBar:(UINavigationBar *)navigationBar
       shouldPopItem:(UINavigationItem *)item{
    UIViewController *vc = self.topViewController;
    
    //返回按钮变色
    [item setHidesBackButton:YES];
    [item setHidesBackButton:NO];
    
    if (item != vc.navigationItem) {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    
    if ([vc conformsToProtocol:@protocol(YYNavigationControllerShouldPopProtocol) ]) {
        if ([(id<YYNavigationControllerShouldPopProtocol>)vc yy_navagationControllerShouldPopWhenSystemBackItemClick:self]) {
            return [super navigationBar:navigationBar shouldPopItem:item];
        }else{
            return NO;
        }
    }else{
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
}


@end
