//
//  CacheUtil.m
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CacheUtil.h"

@implementation CacheUtil

+ (NSInteger)nowTimestamp
{
    return (NSInteger)ceil([[NSDate date] timeIntervalSince1970]);
}

+ (NSInteger)expiredTimestampForLife:(NSInteger)duration
{
    return [CacheUtil nowTimestamp] + duration;
}

+ (NSString *)md5Encrypt:(NSString *)aStr
{
    const char *original_str = [aStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
