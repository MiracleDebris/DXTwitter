//
//  DXTweetViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/13.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXTweetViewController.h"
#import "DXTwitterAnimator.h"

@interface DXTweetViewController ()
@property (nonatomic, strong) DXTwitterAnimator *animator;
@end

@implementation DXTweetViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _animator = [DXTwitterAnimator new];
        self.transitioningDelegate = _animator;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    bar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:bar];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tweet_dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.rightBarButtonItem = dismissItem;
    
    bar.items = @[navigationItem];
    
    
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
