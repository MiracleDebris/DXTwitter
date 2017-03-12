//
//  DXControl.h
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@interface DXControl : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^touchBlock)(DXControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(DXControl *view, CGPoint point);
@end
