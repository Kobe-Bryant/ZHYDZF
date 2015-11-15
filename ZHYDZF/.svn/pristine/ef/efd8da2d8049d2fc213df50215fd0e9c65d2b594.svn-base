//
//  CacheManager.h
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheObject.h"
#import "CacheUtil.h"

#define kHomeCachePath @"PowerDataCache"
#define kBaseCacheName @"archive.data"

@interface CacheManager : NSObject

+ (CacheManager *)shared;

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;

- (CacheObject *)valueForKey:(NSString *)key;

- (void)clearCache;

@end
