//
//  CacheObject.m
//  FoShanYDZF
//
//  Created by 曾静 on 14-1-24.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CacheObject.h"
#import "CacheUtil.h"

@implementation CacheObject

@synthesize data, duration, expiredTime;

- (CacheObject *)initWithData:(id)aData andDuration:(NSInteger)aDuration
{
    if(self = [super init])
    {
        self.data = aData;
        self.duration = aDuration;
        self.expiredTime = [CacheUtil expiredTimestampForLife:aDuration];
    }
    return self;
}

- (CacheObject *)initWithData:(id)aData
{
    return [self initWithData:aData andDuration:60];
}

- (BOOL)expired
{
    if ([CacheUtil nowTimestamp] < self.expiredTime)
    {
        return NO;
    }
    return YES;
}

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:data forKey:@"data"];
    [aCoder encodeInteger:duration forKey:@"duration"];
    [aCoder encodeInteger:expiredTime forKey:@"expiredTime"];
}

//解码对应上面的key
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        data = [aDecoder decodeObjectForKey:@"data"];
        duration = [aDecoder decodeIntegerForKey:@"duration"];
        expiredTime = [aDecoder decodeIntegerForKey:@"expiredTime"];
    }
    return self;
}

@end
