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
#import "DXTabbarItem.h"

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
    for (NSDictionary *dic in dicArray) {
        [arrayM addObject:[self controllerWithDic:dic]];
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



@end







