//
//  CacheObject.h
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheObject : NSObject <NSCoding>

@property (nonatomic, copy) NSString *data;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger expiredTime;

- (CacheObject *)initWithData:(id)aData andDuration:(NSInteger)aDuration;

- (CacheObject *)initWithData:(id)aData;

- (BOOL)expired;

@end
