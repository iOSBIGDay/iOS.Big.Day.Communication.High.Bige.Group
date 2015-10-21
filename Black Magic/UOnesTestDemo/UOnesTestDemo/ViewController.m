//
//  ViewController.m
//  UOnesTestDemo
//
//  Created by 玉文辉 on 15/10/21.
//  Copyright © 2015年 yuwenhui. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgress.h"
#import "ImageCapture.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
//    CircleProgress *view = [[CircleProgress alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
//    [view start:0.72];
//    view.interval = 0.05;
//    [self.view addSubview:view];
    
    UIImage *image = [UIImage imageNamed:@"7.jpg"];
    ImageCapture *imagecpaview = [[ImageCapture alloc] initWithFrame:CGRectMake(50, 50, 200, 200) Image:image];
    [imagecpaview drawImage];
    [self.view addSubview:imagecpaview];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
