//
//  TJCallViewController.m
//  TJTabBarDemo
//
//  Created by tofu on 15/10/20.
//  Copyright © 2015年 Tofu Jelly. All rights reserved.
//

#import "TJCallViewController.h"

@interface TJCallViewController ()

- (IBAction)cancel:(id)sender;

@end

@implementation TJCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3];
    
    [animation setType: kCATransitionFade];
    
    //[animation setSubtype: kCATransitionFromTop];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO ];
    
}
@end
