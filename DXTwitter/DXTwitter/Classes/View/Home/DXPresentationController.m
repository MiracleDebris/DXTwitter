//
//  DXPresentationController.m
//  DXTwitter
//
//  Created by dx on 17/3/13.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXPresentationController.h"

@interface DXPresentationController ()
@property (nonatomic, strong) UIView *darkView;
@end

@implementation DXPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        _darkView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _darkView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    _darkView.alpha = 0;
    [self.containerView insertSubview:_darkView atIndex:0];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _darkView.alpha = 1;
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _darkView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [_darkView removeFromSuperview];
    }];
}

@end











