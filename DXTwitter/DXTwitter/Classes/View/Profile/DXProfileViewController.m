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
#import "DXTableView.h"
#import "DXTableViewCell.h"

NSString *const cellId = @"cellId";

#define kSegmentControlHorizontalPapping 10
#define kSegmentControlVerticalPapping 8
#define kSegmentControlHeight 30
#define kMinHeaderHeight (64 + 30 + 8 * 2)
#define kMaxHeaderHeight 270
#define kMaxBGHeight 120
#define kMinBGHeight 64
#define kTweetButtonTopPadding 28.5
#define kTweetButtonRightPadding -16

#define kTextColorLight [UIColor lightGrayColor]
#define kTextColorDark [UIColor blackColor]
#define kTextVerticalPadding 6
#define kTextHorizontalPadding 10



@interface DXProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DXProfileViewController {
    UIView *_headerView;
    UIImageView *_BGView;
    UIStatusBarStyle _statusBarStyle;
    UIImageView *_avatarView;
    UIButton *_tweetButton;
    DXTableView *_tableView1;
    UISegmentedControl *_segmentControl;
    UILabel *_nickNameLabel;
    UIView *_lineView;
    UIView *_topLabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareHeaderView];
    [self selectView1];
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

- (void)prepareLabelsAndButtons {
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.text = @"MiracleDebris";
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:20];
    _nickNameLabel.textColor = kTextColorDark;
    [_nickNameLabel sizeToFit];
    [_headerView addSubview:_nickNameLabel];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = @"@MiracleDebris";
    userNameLabel.font = [UIFont systemFontOfSize:14];
    userNameLabel.textColor = kTextColorLight;
    [userNameLabel sizeToFit];
    [_headerView addSubview:userNameLabel];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = @"23333333333333";
    introduceLabel.font = [UIFont systemFontOfSize:15];
    introduceLabel.textColor = kTextColorDark;
    [introduceLabel sizeToFit];
    [_headerView addSubview:introduceLabel];
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setBackgroundImage:[UIImage imageNamed:@"profile_settings"] forState:UIControlStateNormal];
    [_headerView addSubview:setButton];
    
    _nickNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    introduceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    setButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_headerView addConstraint:[NSLayoutConstraint
                              constraintWithItem:introduceLabel
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:_segmentControl
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:-kTextVerticalPadding]];
    [_headerView addConstraint:[NSLayoutConstraint
                              constraintWithItem:introduceLabel
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:_headerView
                              attribute:NSLayoutAttributeLeft
                              multiplier:1.0
                              constant:kTextHorizontalPadding]];
    
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:userNameLabel
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                toItem:introduceLabel
                                attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                constant:-kTextVerticalPadding]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:userNameLabel
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                constant:kTextHorizontalPadding]];
    
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_nickNameLabel
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                toItem:userNameLabel
                                attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                constant:-kTextVerticalPadding]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_nickNameLabel
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                constant:kTextHorizontalPadding]];
    
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:setButton
                                attribute:NSLayoutAttributeRight
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                constant:-kTextHorizontalPadding]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:setButton
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:-(kMaxHeaderHeight - kMaxBGHeight - kTextVerticalPadding)]];
}

- (void)prepareAvatarView {
    UIImage *image = [UIImage imageNamed:@"avatar"];
    image = [image imageByRoundCornerRadius:10 corners:UIRectCornerAllCorners borderWidth:5 borderColor:[UIColor whiteColor] borderLineJoin:kCGLineJoinRound];
    _avatarView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_avatarView];
    
    _avatarView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint
                                constraintWithItem:_avatarView
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                toItem:_nickNameLabel
                                attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                constant: 29]];
    [self.view addConstraint:[NSLayoutConstraint
                                constraintWithItem:_avatarView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                constant:kTextHorizontalPadding]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_avatarView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:60]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_avatarView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:60]];
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
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 260)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    [self prepareBGView];
    [self prepareSegmentControl];
    [self prepareLabelsAndButtons];
    [self prepareLineView];
}

- (void)prepareBGView {
    _BGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    _BGView.backgroundColor = [UIColor whiteColor];
    _BGView.image = [UIImage imageNamed:@"bg"];
    _BGView.contentMode = UIViewContentModeScaleAspectFill;
    _BGView.clipsToBounds = YES;
    [self.view addSubview:_BGView];
    
    _topLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, _BGView.width, 25)];
    _topLabelView.backgroundColor = [UIColor clearColor];
//    [self.view insertSubview:_topLabelView belowSubview:_headerView];
//    [self.view addSubview:_topLabelView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"MiracleDebris";
    topLabel.textColor = [UIColor blackColor];
    topLabel.font = [UIFont boldSystemFontOfSize:20];
    [topLabel sizeToFit];
    [_topLabelView addSubview:topLabel];
    
    topLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_topLabelView addConstraint:[NSLayoutConstraint
                              constraintWithItem:topLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:_topLabelView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0]];
    [_topLabelView addConstraint:[NSLayoutConstraint
                              constraintWithItem:topLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:_topLabelView
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0]];
}

- (void)prepareLineView {
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kMaxHeaderHeight, _headerView.width, 0.5)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:_lineView];
}

- (void)prepareSegmentControl {
    NSArray *array = @[@"推文", @"媒体", @"喜欢"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:array];
    _segmentControl.selectedSegmentIndex = 0;
//    [sectionControl addTarget:self action:@selector(selectView1) forControlEvents:UIControlEventValueChanged];
    [_headerView addSubview:_segmentControl];
    
    _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_segmentControl
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:-kSegmentControlVerticalPapping]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_segmentControl
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                toItem:_headerView
                                attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_segmentControl
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                constant:self.view.width - kSegmentControlHorizontalPapping * 2]];
    [_headerView addConstraint:[NSLayoutConstraint
                                constraintWithItem:_segmentControl
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                constant:kSegmentControlHeight]];
}

- (void)selectView1 {
    _tableView1 = [[DXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    [_tableView1 registerClass:[DXTableViewCell class] forCellReuseIdentifier:cellId];
    [_tableView1 setContentInset:UIEdgeInsetsMake(260, 0, 0, 0)];
    [_tableView1 setScrollIndicatorInsets:_tableView1.contentInset];
    
    [self.view insertSubview:_tableView1 belowSubview:_headerView];
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
    
    if (offset <= 0) { // drag down
        [self.view bringSubviewToFront:_avatarView];
        [self.view bringSubviewToFront:_tweetButton];
        _headerView.top = 0;
        _headerView.height = kMaxHeaderHeight - offset;
        _BGView.top = 0;
        _BGView.height = kMaxBGHeight - offset;
        _lineView.top = _headerView.bottom;
        
        _avatarView.layer.transform = CATransform3DIdentity;
        
        CGFloat blurRadius = MIN(-offset, 30);
        _BGView.image = [self blurImageWithProgress:blurRadius];
    } else if (offset < kMaxBGHeight - kMinBGHeight) { // drag up
        [self.view bringSubviewToFront:_avatarView];
        [self.view bringSubviewToFront:_tweetButton];
        _headerView.height = kMaxHeaderHeight;
        _headerView.top = -offset;
        _BGView.height = kMaxBGHeight;
        _BGView.top = -offset;
        _lineView.top = kMaxHeaderHeight;
        
        CGFloat progress = (1 - offset / kMinBGHeight / 2);
        _avatarView.layer.transform = CATransform3DMakeScale(progress, progress, 1);
//        _topLabelView.layer.transform = CATransform3DIdentity;
        
        _BGView.image = [self blurImageWithProgress:0];
    } else if (offset < kMaxHeaderHeight - kMinHeaderHeight) {
        [self.view bringSubviewToFront:_BGView];
        [self.view bringSubviewToFront:_tweetButton];
        _headerView.height = kMaxHeaderHeight;
        _headerView.top = -offset;
        _BGView.height = kMaxBGHeight;
        _BGView.top = -(kMaxBGHeight - kMinBGHeight);
        NSLog(@"%f", offset);
//        _topLabelView.transform = CGAffineTransformMakeTranslation(0, -offset);
//        _topLabelView.layer.transform = CATransform3DMakeTranslation(0, -offset, 0);
        
        CGFloat blurRadius = MIN(offset - kMinBGHeight, 30);
        _BGView.image = [self blurImageWithProgress:blurRadius];
    } else {
        _headerView.height = kMaxHeaderHeight;
        _headerView.top = -(kMaxHeaderHeight - kMinHeaderHeight);
        _BGView.height = kMaxBGHeight;
        _BGView.top = -(kMaxBGHeight - kMinBGHeight);
    }
}

- (UIImage *)blurImageWithProgress:(CGFloat)progress {
    UIImage *image = [UIImage imageNamed:@"bg"];
    image = [image imageByBlurRadius:progress tintColor:nil tintMode:kCGBlendModeNormal saturation:1.0 maskImage:nil];
    return image;
}

@end
















