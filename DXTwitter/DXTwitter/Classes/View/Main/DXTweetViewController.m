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
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBar.barTintColor = [UIColor whiteColor];
    _navBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tweet_dismiss"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    UIImage *image = [UIImage imageNamed:@"avatar"];
    image = [image imageByRoundCornerRadius:10 corners:UIRectCornerAllCorners borderWidth:6 borderColor:[UIColor whiteColor] borderLineJoin:kCGLineJoinRound];
    image = [image imageByResizeToSize:CGSizeMake(40, 40)];
    UIBarButtonItem *avatarItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.rightBarButtonItem = dismissItem;
    navItem.leftBarButtonItem = avatarItem;
    
    _navBar.items = @[navItem];
    [self.view addSubview:_navBar];
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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



















