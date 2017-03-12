//
//  DXStatusLayout.m
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXStatusLayout.h"
#import "DXHelper.h"

@implementation DXStatusLayout

- (void)setTweet:(DXTweet *)tweet {
    if (_tweet != tweet) {
        _tweet = tweet;
        [self layout];
    }
}

- (void)layout {
    [self reset];
    if (!_tweet) {
        if (_conversation) {
            _isConversationSplit = YES;
            _height = kDXConversationSplitHeight;
            return;
        } else {
            return;
        }
    }
    
    if (_conversation) {
        BOOL isTop = NO, isBottom = NO;
        if (_tweet.tidStr) {
            NSUInteger index = [_conversation.contextIDs indexOfObject:_tweet.tidStr];
            if (index == 0) {
                isTop = YES;
            } else if (index + 1 == _conversation.contextIDs.count) {
                isBottom = YES;
            }
        }
        
        if (isTop) {
            _showTopLine = YES;
            _showConversationBottomJoin = YES;
        } else if (isBottom) {
            _showConversationTopJoin = YES;
        } else {
            _showConversationTopJoin = YES;
            _showConversationBottomJoin = YES;
        }
    } else {
        _showTopLine = YES;
    }
    
    DXTweet *tweet = self.displayedTweet;
    
    UIFont *nameSubFont = [UIFont systemFontOfSize:kDXUserNameSubFontSize];
    NSMutableAttributedString *dateText = [[NSMutableAttributedString alloc] initWithString:[DXHelper stringWithTimelineDate:tweet.createdAt]];
    
    if (tweet.card) {
        UIImage *iconImage = [DXHelper imageNamed:@"ic_tweet_attr_summary_default"];
        NSAttributedString *icon = [NSAttributedString attachmentStringWithContent:iconImage contentMode:UIViewContentModeCenter attachmentSize:iconImage.size alignToFont:nameSubFont alignment:YYTextVerticalAlignmentCenter];
        [dateText insertString:@" " atIndex:0];
        [dateText insertAttributedString:icon atIndex:0];
    }
    dateText.font = nameSubFont;
    dateText.color = kDXUserNameSubColor;
    dateText.alignment = NSTextAlignmentRight;
    
    _dateTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kDXContentWidth, kDXUserNameSubFontSize * 2) text:dateText];
    
    
    UIFont *nameFont = [UIFont systemFontOfSize:kDXUserNameFontSize];
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:(tweet.user.name ? tweet.user.name : @"")];
    nameText.font = nameFont;
    nameText.color = kDXUserNameColor;
    if (tweet.user.screenName) {
        NSMutableAttributedString *screenNameText = [[NSMutableAttributedString alloc] initWithString:tweet.user.screenName];
        [screenNameText insertString:@" @" atIndex:0];
        screenNameText.font = nameSubFont;
        screenNameText.color = kDXUserNameSubColor;
        [nameText appendAttributedString:screenNameText];
    }
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(kDXContentWidth - _dateTextLayout.textBoundingRect.size.width - 5, kDXUserNameFontSize * 2)];
    nameContainer.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
    
    
    NSString *socialString = nil;
    if (_tweet.retweetedStatus) {
        if (_tweet.user.name) {
            socialString = [NSString stringWithFormat:@"%@ Retweeted",_tweet.user.name];
        }
    } else if (tweet.inReplyToScreenName) {
        socialString = [NSString stringWithFormat:@"in reply to @%@",tweet.inReplyToScreenName];
    }
    
    if (socialString) {
        NSMutableAttributedString *socialText = [[NSMutableAttributedString alloc] initWithString:socialString];
        socialText.font = nameSubFont;
        socialText.color = kDXUserNameSubColor;
        socialText.lineBreakMode = NSLineBreakByCharWrapping;
        YYTextContainer *socialContainer = [YYTextContainer containerWithSize:CGSizeMake(kDXContentWidth, kDXUserNameFontSize * 2)];
        socialContainer.maximumNumberOfRows = 1;
        _socialTextLayout = [YYTextLayout layoutWithContainer:socialContainer text:socialText];
    }
    
    YYTextContainer *textContainer = [YYTextContainer containerWithSize:CGSizeMake(kDXContentWidth + 2 * kDXTextContainerInset, CGFLOAT_MAX)];
    textContainer.insets = UIEdgeInsetsMake(0, kDXTextContainerInset, 0, kDXTextContainerInset);
    _textLayout = [YYTextLayout layoutWithContainer:textContainer text:[self textForTweet:tweet]];
    
    if (tweet.medias.count || tweet.extendedMedias.count) {
        NSMutableArray *images = [NSMutableArray new];
        NSMutableSet *imageIDs = [NSMutableSet new];
        
        for (DXMedia *media in tweet.medias) {
            if ([media.type isEqualToString:@"photo"]) {
                if (media.mediaSmall && media.mediaLarge) {
                    if (media.midStr && ![imageIDs containsObject:media.midStr]) {
                        [images addObject:media];
                        [imageIDs addObject:media.midStr];
                    }
                }
            }
        }
        
        for (DXMedia *media in tweet.extendedMedias) {
            if ([media.type isEqualToString:@"photo"]) {
                if (media.mediaSmall && media.mediaLarge) {
                    if (media.midStr && ![imageIDs containsObject:media.midStr]) {
                        [images addObject:media];
                        [imageIDs addObject:media.midStr];
                    }
                }
            }
        }
        
        while (images.count > 4) {
            [images removeLastObject];
        }
        if (images.count > 0) {
            _images = images;
        }
    }
    
    
    if (!_images && !_tweet.retweetedStatus && _tweet.quotedStatus) {
        DXTweet *quote = _tweet.quotedStatus;
        NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:(quote.user.name ? quote.user.name : @"")];
        nameText.font = nameFont;
        nameText.color = kDXUserNameColor;
        if (quote.user.screenName) {
            NSMutableAttributedString *screenNameText = [[NSMutableAttributedString alloc] initWithString:quote.user.screenName];
            [screenNameText insertString:@" @" atIndex:0];
            screenNameText.font = nameSubFont;
            screenNameText.color = kDXUserNameSubColor;
            [nameText appendAttributedString:screenNameText];
        }
        nameText.lineBreakMode = NSLineBreakByCharWrapping;
        
        YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(kDXQuoteContentWidth, kDXUserNameFontSize * 2)];
        nameContainer.maximumNumberOfRows = 1;
        _quotedNameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
        
        NSAttributedString *quoteText = [self textForTweet:quote];
        _quotedTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kDXQuoteContentWidth, CGFLOAT_MAX) text:quoteText];
    }
    
    _retweetCountTextLayout = [self retweetCountTextLayoutForTweet:tweet];
    _favoriteCountTextLayout = [self favoriteCountTextLayoutForTweet:tweet];
    
    if (_socialTextLayout) {
        _paddingTop = kDXCellExtendedPadding;
    } else {
        _paddingTop = kDXCellPadding;
    }
    
    _textTop = _paddingTop + kDXUserNameFontSize + kDXCellInnerPadding;
    _textHeight = _textLayout ? (CGRectGetMaxY(_textLayout.textBoundingRect)) : 0;
    _imagesTop = _quoteTop = _textTop + _textHeight + kDXCellInnerPadding;
    if (_images) {
        _imagesHeight = kDXContentWidth * (9.0 / 16.0);
    } else if (_quotedTextLayout) {
        _quoteHeight = 2 * kDXCellPadding + kDXUserNameFontSize + CGRectGetMaxY(_quotedTextLayout.textBoundingRect);
    }
    
    CGFloat height = 0;
    if (_imagesHeight > 0) {
        height = _imagesTop + _imagesHeight;
    } else if (_quoteHeight > 0) {
        height = _quoteTop + _quoteHeight;
    } else {
        height = _textTop + _textHeight;
    }
    height += kDXActionsHeight;
    if (height < _paddingTop + kDXAvatarSize) {
        height = _paddingTop + kDXAvatarSize;
    }
    height += kDXCellExtendedPadding;
    _height = height;
}

- (void)reset {
    _height = 0;
    _paddingTop = 0;
    _textTop = 0;
    _textHeight = 0;
    _imagesTop = 0;
    _imagesHeight = 0;
    _quoteTop = 0;
    _quoteHeight = 0;
    
    _showTopLine = NO;
    _isConversationSplit = NO;
    _showConversationTopJoin = NO;
    _showConversationBottomJoin = NO;
    _socialTextLayout = nil;
    _nameTextLayout = nil;
    _dateTextLayout = nil;
    _textLayout = nil;
    _quotedNameTextLayout = nil;
    _quotedTextLayout = nil;
    _retweetCountTextLayout = nil;
    _favoriteCountTextLayout = nil;
    _images = nil;
}

- (NSAttributedString *)textForTweet:(DXTweet *)tweet{
    if (tweet.text.length == 0) return nil;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tweet.text];
    text.font = [UIFont systemFontOfSize:kDXTextFontSize];
    text.color = kDXTextColor;
    
    for (DXURL *url in tweet.urls) {
        if (url.ranges) {
            for (NSValue *value in url.ranges) {
                [self setHighlightInfo:@{@"DXURL" : url} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"DXURL" : url} withRange:url.range toText:text];
        }
    }
    
    for (DXMedia *media in tweet.medias) {
        if (media.ranges) {
            for (NSValue *value in media.ranges) {
                [self setHighlightInfo:@{@"DXMedia" : media} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"DXMedia" : media} withRange:media.range toText:text];
        }
    }
    
    for (DXMedia *media in tweet.extendedMedias) {
        if (media.ranges) {
            for (NSValue *value in media.ranges) {
                [self setHighlightInfo:@{@"DXMedia" : media} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"DXMedia" : media} withRange:media.range toText:text];
        }
    }
    
    return text;
}

- (void)setHighlightInfo:(NSDictionary*)info withRange:(NSRange)range toText:(NSMutableAttributedString *)text {
    if (range.length == 0 || text.length == 0) return;
    {
        NSString *str = text.string;
        unichar *chars = malloc(str.length * sizeof(unichar));
        if (!chars) return;
        [str getCharacters:chars range:NSMakeRange(0, str.length)];
        
        NSUInteger start = range.location, end = range.location + range.length;
        for (int i = 0; i < str.length; i++) {
            unichar c = chars[i];
            if (0xD800 <= c && c <= 0xDBFF) { // UTF16 lead surrogates
                if (start > i) start++;
                if (end > i) end++;
            }
        }
        free(chars);
        if (end <= start) return;
        range = NSMakeRange(start, end - start);
    }
    
    if (range.location >= text.length) return;
    if (range.location + range.length > text.length) return;
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    border.fillColor = kDXTextHighlightedBackgroundColor;
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:border];
    highlight.userInfo = info;
    
    [text setTextHighlight:highlight range:range];
    [text setColor:kDXTextHighlightedColor range:range];
}

- (DXTweet *)displayedTweet {
    return _tweet.retweetedStatus ? _tweet.retweetedStatus : _tweet;
}

- (YYTextLayout *)retweetCountTextLayoutForTweet:(DXTweet *)tweet {
    if (tweet.retweetCount > 0) {
        NSMutableAttributedString *retweet = [[NSMutableAttributedString alloc] initWithString:[DXHelper shortedNumberDesc:tweet.retweetCount]];
        retweet.font = [UIFont systemFontOfSize:kDXActionFontSize];
        retweet.color = tweet.retweeted ? kDXTextActionRetweetColor : kDXTextActionsColor;
        return [YYTextLayout layoutWithContainerSize:CGSizeMake(100, kDXActionFontSize * 2) text:retweet];
    }
    return nil;
}
- (YYTextLayout *)favoriteCountTextLayoutForTweet:(DXTweet *)tweet {
    if (tweet.favoriteCount > 0) {
        NSMutableAttributedString *favourite = [[NSMutableAttributedString alloc] initWithString:[DXHelper shortedNumberDesc:tweet.favoriteCount]];
        favourite.font = [UIFont systemFontOfSize:kDXActionFontSize];
        favourite.color = tweet.favorited ? kDXTextActionFavoriteColor : kDXTextActionsColor;
        return [YYTextLayout layoutWithContainerSize:CGSizeMake(100, kDXActionFontSize * 2) text:favourite];
    }
    return nil;
}
@end
