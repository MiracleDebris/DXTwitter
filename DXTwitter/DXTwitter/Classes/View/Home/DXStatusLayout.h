//
//  DXStatusLayout.h
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXModel.h"
#import <YYKit/YYKit.h>


#define kDXCellPadding 12
#define kDXCellInnerPadding 6
#define kDXCellExtendedPadding 30
#define kDXAvatarSize 48
#define kDXImagePadding 4
#define kDXConversationSplitHeight 25
#define kDXContentLeft (kDXCellPadding + kDXAvatarSize + kDXCellInnerPadding)
#define kDXContentWidth (kScreenWidth - 2 * kDXCellPadding - kDXAvatarSize - kDXCellInnerPadding)
#define kDXQuoteContentWidth (kDXContentWidth - 2 * kDXCellPadding)
#define kDXActionsHeight 6
#define kDXTextContainerInset 4

#define kDXUserNameFontSize 14
#define kDXUserNameSubFontSize 12
#define kDXTextFontSize 14
#define kDXActionFontSize 12

#define kDXUserNameColor UIColorHex(292F33)
#define kDXUserNameSubColor UIColorHex(8899A6)
#define kDXCellBGHighlightColor [UIColor colorWithWhite:0.000 alpha:0.041]
#define kDXTextColor UIColorHex(292F33)
#define kDXTextHighlightedColor UIColorHex(1A91DA)
#define kDXTextActionsColor UIColorHex(8899A6)
#define kDXTextHighlightedBackgroundColor UIColorHex(ebeef0)

#define kDXTextActionRetweetColor UIColorHex(19CF86)
#define kDXTextActionFavoriteColor UIColorHex(FAB81E)


@interface DXStatusLayout : NSObject

@property (nonatomic, strong) DXTweet *tweet;
@property (nonatomic, strong) DXConversation *conversation;
- (void)layout;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat textTop;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat imagesTop;
@property (nonatomic, assign) CGFloat imagesHeight;
@property (nonatomic, assign) CGFloat quoteTop;
@property (nonatomic, assign) CGFloat quoteHeight;

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL isConversationSplit;
@property (nonatomic, assign) BOOL showConversationTopJoin;
@property (nonatomic, assign) BOOL showConversationBottomJoin;

@property (nonatomic, strong) YYTextLayout *socialTextLayout;
@property (nonatomic, strong) YYTextLayout *nameTextLayout;
@property (nonatomic, strong) YYTextLayout *dateTextLayout;
@property (nonatomic, strong) YYTextLayout *textLayout;

@property (nonatomic, strong) YYTextLayout *quotedNameTextLayout;
@property (nonatomic, strong) YYTextLayout *quotedTextLayout;

@property (nonatomic, strong) YYTextLayout *retweetCountTextLayout;
@property (nonatomic, strong) YYTextLayout *favoriteCountTextLayout;

@property (nonatomic, strong) NSArray<DXMedia *> *images;
@property (nonatomic, readonly) DXTweet *displayedTweet;

- (YYTextLayout *)retweetCountTextLayoutForTweet:(DXTweet *)tweet;
- (YYTextLayout *)favoriteCountTextLayoutForTweet:(DXTweet *)tweet;
@end

















