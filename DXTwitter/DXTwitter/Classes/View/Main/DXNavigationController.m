//
//  DXNavigationController.m
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXNavigationController.h"

@interface DXNavigationController ()

@end

@implementation DXNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
