//
//  DXStatusCell.h
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <YYKit/YYKit.h>
#import "DXStatusLayout.h"
#import "DXControl.h"
#import "DXTableViewCell.h"

@class DXStatusCell;

@interface DXStatusMediaView : DXControl
@property (nonatomic, strong) NSArray<UIImageView *> *imageViews;
@property (nonatomic, weak) DXStatusCell *cell;
@end


@interface DXStatusQuoteView : DXControl
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *textLabel;
@property (nonatomic, weak) DXStatusCell *cell;
@end


@interface DXStatusInlineActionsView : UIView
@property (nonatomic, strong) UIButton *replyButton;

@property (nonatomic, strong) UIButton *retweetButton;
@property (nonatomic, strong) UIImageView *retweetImageView;
@property (nonatomic, strong) YYLabel *retweetLabel;

@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) YYAnimatedImageView *favoriteImageView;
@property (nonatomic, strong) YYLabel *favoriteLabel;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, weak) DXStatusCell *cell;

- (void)updateRetweetWithAnimation;
- (void)updateFavouriteWithAnimation;
- (void)updateFollowWithAnimation;
@end

@interface DXStatusView : DXControl
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *socialIconView;
@property (nonatomic, strong) YYLabel *socialLabel;

@property (nonatomic, strong) DXControl *avatarView;
@property (nonatomic, strong) UIView *conversationTopJoin;
@property (nonatomic, strong) UIView *conversationBottomJoin;

@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *dateLabel;
@property (nonatomic, strong) YYLabel *textLabel;

@property (nonatomic, strong) DXStatusMediaView *mediaView;
@property (nonatomic, strong) DXStatusQuoteView *quoteView;

@property (nonatomic, strong) DXStatusInlineActionsView *inlineActionsView;
@property (nonatomic, weak) DXStatusCell *cell;
@end


@protocol DXStatusCellDelegate <NSObject>
@optional
- (void)cell:(DXStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
- (void)cell:(DXStatusCell *)cell didClickImageAtIndex:(NSUInteger)index withLongPress:(BOOL)longPress;
- (void)cell:(DXStatusCell *)cell didClickQuoteWithLongPress:(BOOL)longPress;
- (void)cell:(DXStatusCell *)cell didClickAvatarWithLongPress:(BOOL)longPress;
- (void)cell:(DXStatusCell *)cell didClickContentWithLongPress:(BOOL)longPress;
- (void)cellDidClickReply:(DXStatusCell *)cell;
- (void)cellDidClickRetweet:(DXStatusCell *)cell;
- (void)cellDidClickFavorite:(DXStatusCell *)cell;
- (void)cellDidClickFollow:(DXStatusCell *)cell;
@end


@interface DXStatusCell : DXTableViewCell
@property (nonatomic, strong) DXStatusView *statusView;
@property (nonatomic, strong) DXStatusLayout *layout;
@property (nonatomic, weak) id<DXStatusCellDelegate> delegate;
@end
