//
//  DXModel.h
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>

@class DXUser;

@interface DXUserMention : NSObject
@property (nonatomic, assign) uint32_t uid;
@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *name;       // e.g. "Nick Lockwood"
@property (nonatomic, strong) NSString *screenName; // e.g. "nicklockwood"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;     // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;        // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;      // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@property (nonatomic, strong) DXUser *user;         // reference
@end


@interface DXURL : NSObject
@property (nonatomic, strong) NSString *url;         // e.g. "http://t.co/YuvsPou0rj"
@property (nonatomic, strong) NSString *displayURL;  // e.g. "apple.com/tv/compare/"
@property (nonatomic, strong) NSString *expandedURL; // e.g. "http://www.apple.com/tv/compare/"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;      // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;         // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;       // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@end


@interface DXHashTag : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<NSNumber *> *indices;  // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;     // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;   // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@end


@interface DXMediaMeta : NSObject
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) NSString *resize; // fit, crop
@property (nonatomic, assign) BOOL isCrop;      // resize is "crop"
@property (nonatomic, strong) NSArray<NSValue *> *faces;   // Array<NSValue(CGRect)>
@property (nonatomic, strong) NSURL *url;       // add
@end


@interface DXMedia : NSObject
@property (nonatomic, assign) uint64_t mid;
@property (nonatomic, strong) NSString *midStr;
@property (nonatomic, strong) NSString *type;          // photo/..
@property (nonatomic, strong) NSString *url;           // e.g. "http://t.co/X4kGxbKcBu"
@property (nonatomic, strong) NSString *displayURL;    // e.g. "pic.twitter.com/X4kGxbKcBu"
@property (nonatomic, strong) NSString *expandedURL;   // e.g. "http://twitter.com/edelwax/status/652117831883034624/photo/1"
@property (nonatomic, strong) NSString *mediaURL;      // e.g. "http://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"
@property (nonatomic, strong) NSString *mediaURLHttps; // e.g. "https://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;        // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;           // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;         // Array<NSValue(NSRange)> nil if range is less than or equal to one.

@property (nonatomic, strong) DXMediaMeta *mediaThumb;
@property (nonatomic, strong) DXMediaMeta *mediaSmall;
@property (nonatomic, strong) DXMediaMeta *mediaMedium;
@property (nonatomic, strong) DXMediaMeta *mediaLarge;
@property (nonatomic, strong) DXMediaMeta *mediaOrig;
@end


@interface DXPlace : NSObject
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *placeType;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSArray *containedWithin;
@property (nonatomic, strong) NSDictionary *boundingBox;
@property (nonatomic, strong) NSDictionary *attributes;
@end


@interface DXCard : NSObject
@property (nonatomic, strong) NSDictionary *users; // <NSString(uid), T1User>
@property (nonatomic, strong) NSString *cardTypeURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *bindingValues;
@end


@interface DXUser : NSObject
@property (nonatomic, assign) uint64_t uid;
@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *name;       // e.g. "Nick Lockwood"
@property (nonatomic, strong) NSString *screenName; // e.g. "nicklockwood"
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, assign) uint32_t listedCount;
@property (nonatomic, assign) uint32_t statusesCount;
@property (nonatomic, assign) uint32_t favouritesCount;
@property (nonatomic, assign) uint32_t friendsCount;

// http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_normal.jpeg original
// http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_reasonably_small.jpeg replaced
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *profileImageURLReasonablySmall; // replaced
@property (nonatomic, strong) NSURL *profileImageURLHttps;
@property (nonatomic, strong) NSURL *profileBackgroundImageURL;
@property (nonatomic, strong) NSURL *profileBackgroundImageURLHttps;

@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *profileTextColor;
@property (nonatomic, strong) NSString *profileSidebarFillColor;
@property (nonatomic, strong) NSString *profileSidebarBorderColor;
@property (nonatomic, strong) NSString *profileLinkColor;

@property (nonatomic, strong) NSDictionary *entities;
@property (nonatomic, strong) NSDictionary *counts;

@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL followRequestSent;
@property (nonatomic, assign) BOOL defaultProfile;
@property (nonatomic, assign) BOOL defaultProfileImage;
@property (nonatomic, assign) BOOL profileBackgroundTile;
@property (nonatomic, assign) BOOL profileUseBackgroundImage;
@property (nonatomic, assign) BOOL isProtected;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, assign) BOOL notifications;
@property (nonatomic, assign) BOOL geoEnabled;
@property (nonatomic, assign) BOOL contributorsEnabled;
@property (nonatomic, assign) BOOL isTranslationEnabled;
@property (nonatomic, assign) BOOL hasExtendedProfile;

@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, assign) int32_t utcOffset;
@end


@interface DXTweet : NSObject
@property (nonatomic, assign) uint64_t tid;
@property (nonatomic, strong) NSString *tidStr;

@property (nonatomic, strong) DXUser *user;
@property (nonatomic, strong) DXPlace *place;
@property (nonatomic, strong) DXCard *card;
@property (nonatomic, strong) DXTweet *retweetedStatus;
@property (nonatomic, strong) DXTweet *quotedStatus;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSArray<DXMedia *> *medias;
@property (nonatomic, strong) NSArray<DXMedia *> *extendedMedias;
@property (nonatomic, strong) NSArray<DXUserMention *> *userMentions;
@property (nonatomic, strong) NSArray<DXURL *> *urls;
@property (nonatomic, strong) NSArray<DXHashTag *> *hashTags;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL isQuoteStatus;
@property (nonatomic, assign) uint32_t favoriteCount;
@property (nonatomic, assign) uint32_t retweetCount;
@property (nonatomic, assign) uint64_t conversationID;
@property (nonatomic, assign) uint32_t isReplyToUserId;
@property (nonatomic, strong) NSArray *contributors;
@property (nonatomic, assign) uint64_t inReplyToStatusID;
@property (nonatomic, strong) NSString *inReplyToStatusIDStr;
@property (nonatomic, strong) NSString *inReplyToUserIDStr;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSString *supplementalLanguage;
@property (nonatomic, strong) NSArray *coordinates;
@end


@interface DXConversation : NSObject
@property (nonatomic, strong) NSString *targetTweeyID;
@property (nonatomic, strong) NSArray *participantIDs;
@property (nonatomic, assign) uint32_t participantsCount;
@property (nonatomic, assign) uint32_t targetCount;
@property (nonatomic, strong) NSString *rootUserID;
@property (nonatomic, strong) NSArray *contextIDs;
@property (nonatomic, strong) NSArray *entityIDs;

@property (nonatomic, strong) NSArray *tweets;
@end


@interface DXAPIRespose : NSObject
@property (nonatomic, strong) NSDictionary *moments;
@property (nonatomic, strong) NSDictionary<NSString *, DXUser *> *users;
@property (nonatomic, strong) NSDictionary<NSString *, DXTweet *> *tweets;
@property (nonatomic, strong) NSArray *timelineItems;
@property (nonatomic, strong) NSArray *timeline;

@property (nonatomic, strong) NSString *cursorTop;
@property (nonatomic, strong) NSString *cursorBottom;
@property (nonatomic, strong) NSArray *cursorGaps;
@end












