//
//  DXHelper.h
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>

@interface DXHelper : NSObject

+ (NSBundle *)bundle;

+ (YYMemoryCache *)imageCache;

+ (UIImage *)imageNamed:(NSString *)name;

+ (NSString *)stringWithTimelineDate:(NSDate *)date;

+ (NSString *)shortedNumberDesc:(NSUInteger)number;

@end
