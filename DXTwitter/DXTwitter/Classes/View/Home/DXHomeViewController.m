//
//  DXHomeViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/11.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXHomeViewController.h"
#import <YYKit/YYKit.h>
#import "DXModel.h"
#import "DXStatusLayout.h"
#import "DXStatusCell.h"
#import "DXSimpleWebViewController.h"
#import "DXPhotoGroupView.h"
#import "DXTableView.h"
//#import "DXTwitterTransition.h"
#import "DXNavigationController.h"
#import "DXTweetViewController.h"

@interface DXHomeViewController () <UITableViewDelegate, UITableViewDataSource, DXStatusCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
//@property (nonatomic, strong) DXTwitterTransitionDelegate *transitionDelegate;
@end

@implementation DXHomeViewController {
    BOOL _statusBarHidden;
}

- (instancetype)init {
    self = [super init];
    _tableView = [DXTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    _statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _statusBarHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.919];
    
    [self setupNavBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.transitioningDelegate = [DXTwitterTransitionDelegate new];
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *layouts = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"twitter_%d.json", i]];
            DXAPIRespose *response = [DXAPIRespose modelWithJSON:data];
            for (id item in response.timelineItems) {
                if ([item isKindOfClass:[DXTweet class]]) {
                    DXTweet *tweet = item;
                    DXStatusLayout *layout = [DXStatusLayout new];
                    layout.tweet = tweet;
                    [layouts addObject:layout];
                } else if ([item isKindOfClass:[DXConversation class]]) {
                    DXConversation *conv = item;
                    NSMutableArray *convLayouts = [NSMutableArray array];
                    for (DXTweet *tweet in conv.tweets) {
                        DXStatusLayout *layout = [DXStatusLayout new];
                        layout.conversation = conv;
                        layout.tweet = tweet;
                        [convLayouts addObject:layout];
                    }
                    if (conv.targetCount > 0 && convLayouts.count >= 2) {
                        DXStatusLayout *split = [DXStatusLayout new];
                        split.conversation = conv;
                        [split layout];
                        [convLayouts insertObject:split atIndex:1];
                    }
                    [layouts addObjectsFromArray:convLayouts];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            self.layouts = layouts;
            [_tableView reloadData];
        });
    });
}

- (void)setupNavBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"follow"] style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tweet"] style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
    self.navigationController.navigationBar.tintColor = UIColorHex(55acee);
}

- (void)follow {
    
}

- (void)tweet {
    DXTweetViewController *vc = [DXTweetViewController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"DXCell";
    DXStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DXStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((DXStatusLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - DXStatusCellDelegate

- (void)cell:(DXStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    YYTextHighlight *highlight = [label.textLayout.text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    NSURL *link = nil;
    NSString *linkTitle = nil;
    if (info[@"DXURL"]) {
        DXURL *url = info[@"DXURL"];
        if (url.expandedURL.length) {
            link = [NSURL URLWithString:url.expandedURL];
            linkTitle = url.displayURL;
        }
    } else if (info[@"DXMedia"]) {
        DXMedia *media = info[@"DXMedia"];
        if (media.expandedURL.length) {
            link = [NSURL URLWithString:media.expandedURL];
            linkTitle = media.displayURL;
        }
    }
    if (link) {
        DXSimpleWebViewController *vc = [[DXSimpleWebViewController alloc] initWithURL:link];
        vc.title = linkTitle;
        [self.navigationController
         pushViewController:vc animated:YES];
    }
}

- (void)cell:(DXStatusCell *)cell didClickImageAtIndex:(NSUInteger)index withLongPress:(BOOL)longPress {
    if (longPress) {
        return;
    }
    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray array];
    NSArray<DXMedia *> *images = cell.layout.images;
    
    for (NSUInteger i = 0, max = images.count; i < max; i++) {
        UIImageView *imgView = cell.statusView.mediaView.imageViews[i];
        DXMedia *img = images[i];
        DXPhotoGroupItem *item = [DXPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = img.mediaLarge.url;
        item.largeImageSize = img.mediaLarge.size;
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    DXPhotoGroupView *v = [[DXPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.tabBarController.view animated:YES completion:nil];
}

- (void)cell:(DXStatusCell *)cell didClickQuoteWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(DXStatusCell *)cell didClickAvatarWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(DXStatusCell *)cell didClickContentWithLongPress:(BOOL)longPress {
    
}

- (void)cellDidClickReply:(DXStatusCell *)cell {
    
}

- (void)cellDidClickRetweet:(DXStatusCell *)cell {
    DXStatusLayout *layout = cell.layout;
    DXTweet *tweet = layout.displayedTweet;
    if (tweet.retweeted) {
        tweet.retweeted = NO;
        if (tweet.retweetCount > 0) tweet.retweetCount--;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    } else {
        tweet.retweeted = YES;
        tweet.retweetCount++;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateRetweetWithAnimation];
}

- (void)cellDidClickFavorite:(DXStatusCell *)cell {
    DXStatusLayout *layout = cell.layout;
    DXTweet *tweet = layout.displayedTweet;
    if (tweet.favorited) {
        tweet.favorited = NO;
        if (tweet.favoriteCount > 0) tweet.favoriteCount--;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    } else {
        tweet.favorited = YES;
        tweet.favoriteCount++;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateFavouriteWithAnimation];
}

- (void)cellDidClickFollow:(DXStatusCell *)cell {
    DXStatusLayout *layout = cell.layout;
    DXTweet *tweet = layout.displayedTweet;
    tweet.user.following = !tweet.user.following;
    [cell.statusView.inlineActionsView updateFollowWithAnimation];
}

@end














