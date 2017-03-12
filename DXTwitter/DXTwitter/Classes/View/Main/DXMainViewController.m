//
//  DXMainViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/11.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXMainViewController.h"
#import "DXBaseViewController.h"
#import <YYKit.h>

@interface DXMainViewController () <UITabBarDelegate>

@end

@implementation DXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"main.json" ofType:nil]];
    NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < dicArray.count; i++) {
        UIViewController *vc = [self controllerWithDic:dicArray[i]];
        vc.tabBarItem.tag = i;
        [arrayM addObject:vc];
    }
    self.viewControllers = arrayM.copy;
}

- (UIViewController *)controllerWithDic:(NSDictionary *)dic {
    NSString *clsName = dic[@"clsName"];
    NSString *title = dic[@"title"];
    NSString *imageName = dic[@"imageName"];
    Class cls = NSClassFromString(clsName);
    DXBaseViewController *vc = [cls new];
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"icn_tab_%@_default", imageName]];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"icn_tab_%@_selected", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorHex(55acee)} forState:UIControlStateHighlighted];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = 0;
    NSInteger itemTag = item.tag;
    for (UIView *subView in tabBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == itemTag) {
                for (UIView *v in subView.subviews) {
                    if ([v isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                        anim.values = @[@1.0, @0.9, @1.05, @0.97, @1.0];
                        anim.duration = 0.4;
                        anim.calculationMode = kCAAnimationCubic;
                        [v.layer addAnimation:anim forKey:nil];
                    }
                }
            }
            index++;
        }
    }
}


@end







