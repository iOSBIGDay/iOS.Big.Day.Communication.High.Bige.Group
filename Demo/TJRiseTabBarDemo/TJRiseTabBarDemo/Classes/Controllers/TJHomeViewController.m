//
//  TJHomeViewController.m
//  TJTabBarDemo
//
//  Created by tofu on 15/10/20.
//  Copyright © 2015年 Tofu Jelly. All rights reserved.
//

#import "TJHomeViewController.h"
#import "TJPushViewController.h"

@interface TJHomeViewController ()

- (IBAction)push:(id)sender;

@end

@implementation TJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)push:(id)sender {
    TJPushViewController *nextPush = [[TJPushViewController alloc] init];
    [nextPush setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nextPush animated:YES];
}
@end
