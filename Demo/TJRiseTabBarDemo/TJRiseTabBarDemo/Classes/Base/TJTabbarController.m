//
//  TJTabbarController.m
//  TJRiseTabBarDemo
//
//  Created by tofu on 15/10/20.
//  Copyright © 2015年 Tofu Jelly. All rights reserved.
//

#import "TJTabbarController.h"
#import "TJHomeViewController.h"
#import "TJAmusementViewController.h"
#import "TJCallViewController.h"
#import "TJContactViewController.h"
#import "TJMineViewController.h"
#import "TJNavigationController.h"
#import "LLTabBar.h"
#import "LLTabBarItem.h"

#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface TJTabbarController ()<LLTabBarDelegate,UIActionSheetDelegate>

@end

@implementation TJTabbarController

-(instancetype)init{
    if (self = [super init]) {
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TJHomeViewController      *home      = [[TJHomeViewController alloc] init];
        [self addOneChildVc:home title:@"Home"];
        
        TJAmusementViewController *amusement = [[TJAmusementViewController alloc] init];
        [self addOneChildVc:amusement title:@"Category"];
        
        TJContactViewController   *contact   = [[TJContactViewController alloc] init];
        [self addOneChildVc:contact title:@"Cart"];
        
        TJMineViewController      *mine      = [[TJMineViewController alloc] init];
        [self addOneChildVc:mine title:@"Me"];

    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self createCustomTabBar];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // 此处通过界面调试发现，系统会创建和 viewControllers 相同数量的 UITabBarItem
    // 需要移除保证自定义的 TabBar 可以正常工作
    for (UIView *subview in self.tabBar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            [subview removeFromSuperview];
        }
    }
}
/**
 *  创建自定义 TabBar
 *
 *  此处使用网络开源的思路 
 *  原文地址： https://github.com/NoCodeNoWife/LLRiseTabBar-iOS 
 *  作者： @我的眼里只有代码 ,顺便解决了一些问题
 */
-(void)createCustomTabBar{
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:self.tabBar.bounds];
    CGFloat normalButtonWidth = (SCREEN_WIDTH * 3 / 4) / 4;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat callItemWidth = (SCREEN_WIDTH / 4);
    
    LLTabBarItem *homeItem = [self tabBarItemWithFrame:CGRectMake(0, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"Home"
                                       normalImageName:@"tabbar_home_normal"
                                     selectedImageName:@"tabbar_home_selected"
                                        tabBarItemType:LLTabBarItemTypeNormal];
    LLTabBarItem *amusementItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight)
                                                      title:@"Category"
                                            normalImageName:@"tabbar_category_normal"
                                          selectedImageName:@"tabbar_category_selected"
                                             tabBarItemType:LLTabBarItemTypeNormal];
    LLTabBarItem *callItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2 , 0, callItemWidth, tabBarHeight)
                                                 title:@""
                                       normalImageName:@"post_normal"
                                     selectedImageName:@"post_normal"
                                        tabBarItemType:LLTabBarItemTypeRise];
    LLTabBarItem *contactItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2 + callItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                    title:@"Cart"
                                          normalImageName:@"tabbar_shop_cart_normal"
                                        selectedImageName:@"tabbar_shop_cart_selected"
                                           tabBarItemType:LLTabBarItemTypeNormal];
    LLTabBarItem *mineItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 3 + callItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"Me"
                                       normalImageName:@"tabbar_profile_normal"
                                     selectedImageName:@"tabbar_profile_selected" tabBarItemType:LLTabBarItemTypeNormal];
    tabBar.tabBarItems = @[homeItem,amusementItem,callItem,contactItem,mineItem];
    tabBar.delegate = self;
    [self.tabBar addSubview:tabBar];
}


#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:viewController.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %ld", buttonIndex);
}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:8];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setImage:selectedImage forState:UIControlStateHighlighted];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           需要添加的子控制器
 *  @param title             需要调节自控制器的标题
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title
{
    // 1.设置子控制器的属性
    //    childVc.view.backgroundColor = IWRandomColor;
    childVc.title = title;
    // 给每一个子控制器包装一个导航控制器
    TJNavigationController *nav = [[TJNavigationController alloc] init];
    [nav addChildViewController:childVc];
    
    
    // 2.将自控制器添加到tabbar控制器中
    [self addChildViewController:nav];
    
}


@end
