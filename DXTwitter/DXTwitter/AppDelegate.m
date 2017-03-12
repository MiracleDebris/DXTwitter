//
//  AppDelegate.m
//  DXTwitter
//
//  Created by dx on 17/3/11.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "AppDelegate.h"
#import "DXMainViewController.h"
#import <YYKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    DXMainViewController *rootVC = [[DXMainViewController alloc] init];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    
    [self launchAnimation];
    
    return YES;
}

- (void)launchAnimation {
    _window.backgroundColor = UIColorHex(55acee);
    UIView *view = _window.rootViewController.view;
    
    UIView *launchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchView.backgroundColor = [UIColor whiteColor];
    [view addSubview:launchView];
    [view bringSubviewToFront:launchView];
    
    CALayer *logo = [CALayer layer];
    logo.contents = (__bridge id _Nullable)([UIImage imageNamed:@"logo"].CGImage);
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.bounds = CGRectMake(0, 0, 60, 60);
    logo.position = view.center;
    view.layer.mask = logo;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    anim.duration = 1.0;
    anim.beginTime = CACurrentMediaTime() + 1;
    anim.values = @[[NSValue valueWithCGRect:view.layer.mask.bounds], [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)], [NSValue valueWithCGRect:CGRectMake(0, 0, 4000, 4000)]];
    anim.keyTimes = @[@0, @0.5, @1];
    anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [view.layer.mask addAnimation:anim forKey:nil];
    
    [UIView animateWithDuration:0.25 delay:1.3 options:0 animations:^{
        launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.25 delay:1.3 options:0 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.layer.mask = nil;
        } completion:nil];
    }];
}



@end








