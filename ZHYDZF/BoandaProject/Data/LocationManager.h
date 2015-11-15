//
//  LocationManager.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-24.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NSURLConnHelper.h"
#import "LocationHelper.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate, NSURLConnHelperDelegate>

@property (nonatomic, assign) NSTimeInterval scheduleTime; //重复时间间隔
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *fetchLocationTimer;

@property (nonatomic, strong) NSURLConnHelper *uploadConnection;

@property (nonatomic, strong) LocationHelper *locationHelper;

@property (nonatomic, strong) NSString *currentLat;//当前定位的纬度
@property (nonatomic, strong) NSString *currentLon;//当前定位的经度

+ (id)standardManager;

/**
 *  开始获取用户位置信息
 *
 *  @param timeInterval 重复时间间隔
 */
- (void)startFetchLocationWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  停止获取用户位置数据
 */
- (void)stopFetchLocation;

/**
 *  提交用户的位置数据
 *
 *  @param lat 纬度
 *  @param lon 经度
 */
- (void)commitUserLatitude:(NSString *)lat Longitude:(NSString *)lon;

/**
 *  提交用户指定时间段内的位置数据
 *
 *  @param uid  用户编号
 *  @param time 指定截止时间
 */
- (void)commitUserLocation:(NSString *)uid beforeTime:(NSString *)time;

/**
 *  删除用户指定时间段内的位置数据
 *
 *  @param uid  用户编号
 *  @param time 指定截止时间
 */
- (void)removeUserLocation:(NSString *)uid beforeTime:(NSString *)time;

/**
 *  是否是夜间
 *
 *  @return YES是夜间
 */
- (BOOL)isNight;

@end
