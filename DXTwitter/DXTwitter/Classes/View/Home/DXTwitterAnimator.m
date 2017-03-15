//
//  DXTwitterAnimator.m
//  DXTwitter
//
//  Created by dx on 17/3/13.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXTwitterAnimator.h"

#define scale 0.93

@interface DXTwitterAnimator ()
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation DXTwitterAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _isPresenting = NO;
        _dimmingView = [UIView new];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    return self;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresenting = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    _dimmingView.frame = containerView.bounds;
    [containerView insertSubview:_dimmingView atIndex:0];
    
    if(_isPresenting) {
        [containerView addSubview:toView];
    }
    
    UIViewController *animatingVC = _isPresenting ? toVC : fromVC;
    UIView *animatingView = animatingVC.view;
    
    CGRect appearedFrame = [transitionContext finalFrameForViewController:animatingVC];
    CGRect dismissedFrame = appearedFrame;
    dismissedFrame.origin.y += dismissedFrame.size.height;
    CGRect initialFrame = _isPresenting ? dismissedFrame : appearedFrame;
    CGRect finalFrame = _isPresenting ? appearedFrame : dismissedFrame;
    [animatingView setFrame:initialFrame];
    
    if (_isPresenting) {
        fromView.userInteractionEnabled = NO;
        _dimmingView.alpha = 0;
        [fromVC beginAppearanceTransition:NO animated:YES];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromView.transform = CGAffineTransformMakeScale(scale, scale);
            animatingView.frame = finalFrame;
            _dimmingView.alpha = 1;
        } completion:^(BOOL finished) {
            [fromVC endAppearanceTransition];
            [transitionContext completeTransition:YES];
        }];
    } else {
        toView.userInteractionEnabled = YES;
        toView.transform = CGAffineTransformMakeScale(scale, scale);
        [toVC beginAppearanceTransition:YES animated:YES];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toView.transform = CGAffineTransformIdentity;
            animatingView.frame = finalFrame;
            _dimmingView.alpha = 0;
        } completion:^(BOOL finished) {
            [toVC endAppearanceTransition];
            [transitionContext completeTransition:YES];
            [_dimmingView removeFromSuperview];
        }];
    }
}

@end



















