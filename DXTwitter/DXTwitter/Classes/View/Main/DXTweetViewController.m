//
//  DXTweetViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/13.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXTweetViewController.h"
#import "DXTwitterAnimator.h"
#import <YYKit/YYKit.h>

#define kToolbarHeight (35 + 46)

@interface DXTweetViewController () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, strong) DXTwitterAnimator *animator;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIView *toolbar;
@end

@implementation DXTweetViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _animator = [DXTwitterAnimator new];
        self.transitioningDelegate = _animator;
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self _initTextView];
    [self _initNavBar];
}

- (void)_initNavBar {
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    _navBar.barTintColor = [UIColor whiteColor];
    _navBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tweet_dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.rightBarButtonItem = dismissItem;
    
    _navBar.items = @[navItem];
    [self.view addSubview:_navBar];
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(64, 0, kToolbarHeight, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:20];
    _textView.delegate = self;
    
    NSString *placeholderPalinText = @"有什么新鲜事？";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:placeholderPalinText];
    attr.color = [UIColor lightGrayColor];
    attr.font = [UIFont systemFontOfSize:20];
    _textView.placeholderAttributedText = attr;
    
    [self.view addSubview:_textView];
}

- (void)dismissVC {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - YYTextKeyboardObserver

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    
}

@end



















