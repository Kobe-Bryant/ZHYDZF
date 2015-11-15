//
//  CacheUtil.h
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> 

@interface CacheUtil : NSObject

+ (NSInteger)expiredTimestampForLife:(NSInteger)duration;

+ (NSInteger)nowTimestamp;

+ (NSString *)md5Encrypt:(NSString *)aStr;

@end
