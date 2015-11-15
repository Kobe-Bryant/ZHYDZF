//
//  LocationHelper.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"
#import "LocationItem.h"

@interface LocationHelper : SqliteHelper

/**
 *  添加一个位置数据
 *
 *  @param item 位置数据
 */
- (void)addLocation:(LocationItem *)item;

/**
 *  获取指定用户的全部位置数据
 *
 *  @param uid 用户编号
 *
 *  @return 位置数据
 */
- (NSArray *)queryUserLocation:(NSString *)uid;

/**
 *  获取指定用户的位置数据
 *
 *  @param uid      用户编号
 *  @param fromTime 开始时间
 *  @param endTime  结束时间
 *  @param count    数据条数
 *
 *  @return 位置数据
 */
- (NSArray *)queryUserLocation:(NSString *)uid
                      fromTime:(NSString *)fromTime
                       endTime:(NSString *)endTime
                         count:(int)count;

/**
 *  获取指定用户的指定时间段内的位置数据
 *
 *  @param uid      用户编号
 *  @param fromTime 开始时间
 *  @param endTime  结束时间
 *
 *  @return 位置数据
 */
- (NSArray *)queryUserLocation:(NSString *)uid
                      fromTime:(NSString *)fromTime
                       endTime:(NSString *)endTime;

/**
 *  删除指定用户指定时间段内的位置数据
 *
 *  @param uid      用户编号
 *  @param fromTime 开始时间
 *  @param endTime  结束时间
 *  @param count    记录条数
 *
 *  @return 是否删除完成
 */
- (BOOL)removeUserLocation:(NSString *)uid
                  fromTime:(NSString *)fromTime
                   endTime:(NSString *)endTime
                     count:(int)count;

/**
 *  删除指定用户指定时间段内的位置数据
 *
 *  @param uid      用户编号
 *  @param fromTime 开始时间
 *  @param endTime  结束时间
 *
 *  @return 是否删除完成
 */
- (BOOL)removeUserLocation:(NSString *)uid
                  fromTime:(NSString *)fromTime
                   endTime:(NSString *)endTime;

/**
 *  删除指定用户的位置数据
 *
 *  @param uuid 用户编号
 */
- (void)deleteLocation:(NSString *)uuid;

@end
