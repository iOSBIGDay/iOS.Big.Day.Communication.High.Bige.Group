//
//  TJPushViewController.m
//  TJRiseTabBarDemo
//
//  Created by tofu on 15/10/21.
//  Copyright © 2015年 Tofu Jelly. All rights reserved.
//

#import "TJPushViewController.h"
#import "YYNavigationControllerShouldPopProtocol.h"

@interface TJPushViewController ()<YYNavigationControllerShouldPopProtocol>

@end

@implementation TJPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Push"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ShouldPop Delegate
-(BOOL)yy_navagationControllerShouldPopWhenSystemBackItemClick:(TJNavigationController *)navigationController{
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"我就问你，确定要返回吗？"
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil]
     show];
    
    return NO;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
