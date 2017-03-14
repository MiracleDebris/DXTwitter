//
//  DXProfileViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/11.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXProfileViewController.h"
#import <YYKit/YYKit.h>
#import "DXTweetViewController.h"

NSString *const cellId = @"cellId";
#define kMinHeaderHeight 64
#define kMaxHeaderHeight 150
#define kTweetButtonTopPadding 28.5
#define kTweetButtonRightPadding -16
#define kTableHeaderViewHeight 100

@interface DXProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DXProfileViewController {
    UITableView *_tableView;
    UIView *_headerView;
    UIImageView *_headerImageView;
    UIStatusBarStyle _statusBarStyle;
    UIImageView *_avatarView;
    UIButton *_tweetButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareHeaderView];
    [self prepareTableView];
    [self prepareTweetButton];
    [self prepareAvatarView];
    
    _statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (void)prepareAvatarView {
    UIImage *image = [UIImage imageNamed:@"avatar"];
    image = [image imageByRoundCornerRadius:10 corners:UIRectCornerAllCorners borderWidth:5 borderColor:[UIColor whiteColor] borderLineJoin:kCGLineJoinRound];
    _avatarView = [[UIImageView alloc] initWithImage:image];
    //    _avatarView.frame = CGRectMake(10, kMaxHeaderHeight - 40, 80, 80);
    //    [self.view addSubview:_avatarView];
    _avatarView.frame = CGRectMake(10, -40, 80, 80);
    [_tableView addSubview:_avatarView];
    
}

- (void)tweet {
    DXTweetViewController *vc = [DXTweetViewController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)prepareTweetButton {
    _tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tweetButton setBackgroundImage:[[UIImage imageNamed:@"profile_tweet"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_tweetButton addTarget:self action:@selector(tweet) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_tweetButton];
    [self.view bringSubviewToFront:_tweetButton];
    
    _tweetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_tweetButton
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:kTweetButtonTopPadding]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_tweetButton
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1.0
                              constant:kTweetButtonRightPadding]];
}

- (void)prepareHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kMaxHeaderHeight)];
    _headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_headerView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    _headerImageView.backgroundColor = [UIColor lightGrayColor];
    
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.image = [UIImage imageNamed:@"bg"];
    
    [_headerView addSubview:_headerImageView];
}

- (void)prepareTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.clipsToBounds = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    [_tableView setContentInset:UIEdgeInsetsMake(kMaxHeaderHeight, 0, 0, 0)];
    [_tableView setScrollIndicatorInsets:_tableView.contentInset];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTableHeaderViewHeight)];
    v.backgroundColor = [UIColor greenColor];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.text = @"MiracleDebris";
    nickNameLabel.textColor = [UIColor blackColor];
    nickNameLabel.font = [UIFont boldSystemFontOfSize:20];
    [nickNameLabel sizeToFit];
    [v addSubview:nickNameLabel];
    
    _tableView.tableHeaderView = v;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    if (offset <= 0) { /// drag down
        [self.view insertSubview:_tableView belowSubview:_tweetButton];
        _headerView.top = 0;
        _headerView.height = kMaxHeaderHeight - offset;
        
        CGFloat blurRadius = MIN(-offset, 30);
        _headerImageView.image = [self blurImageWithProgress:blurRadius];
    } else if (offset < kMaxHeaderHeight - kMinHeaderHeight) {
        _headerView.height = kMaxHeaderHeight;
        _headerImageView.height = _headerView.height;
        _headerView.top = -offset;
    } else {
        [self.view insertSubview:_headerView belowSubview:_tweetButton];
        _headerView.height = kMaxHeaderHeight;
        _headerImageView.height = _headerView.height;
        _headerView.top = -(kMaxHeaderHeight - kMinHeaderHeight);
        
        CGFloat blurRadius = MIN(scrollView.contentOffset.y + kMinHeaderHeight, 30);
        _headerImageView.image = [self blurImageWithProgress:blurRadius];
    }
    _headerImageView.height = _headerView.height;
}

- (UIImage *)blurImageWithProgress:(CGFloat)progress {
    UIImage *image = [UIImage imageNamed:@"bg"];
    image = [image imageByBlurRadius:progress tintColor:nil tintMode:kCGBlendModeNormal saturation:1.0 maskImage:nil];
    return image;
}

@end
















