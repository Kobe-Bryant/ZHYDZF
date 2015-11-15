//
//  LocationManager.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-24.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LocationManager.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "LocationItem.h"
#import "GUIDGenerator.h"
#import "PDJsonkit.h"

@implementation LocationManager

+ (id)standardManager
{
    static LocationManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LocationManager alloc] init];
    });
    return _instance;
}

- (void)startFetchLocationWithTimeInterval:(NSTimeInterval)timeInterval
{
    if(timeInterval <= 0)
    {
        timeInterval = 5.0;
    }
    NSTimer *preventSleepTimer = [[NSTimer alloc] initWithFireDate:[NSDate date]
	                                                      interval:timeInterval
	                                                        target:self
	                                                      selector:@selector(fetchUserLocationData)
	                                                      userInfo:nil
	                                                       repeats:YES];
    if(self.fetchLocationTimer)
    {
        [self.fetchLocationTimer invalidate];
        self.fetchLocationTimer = nil;
    }
	self.fetchLocationTimer = preventSleepTimer;
	[[NSRunLoop currentRunLoop] addTimer:self.fetchLocationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopFetchLocation
{
    //停止定位
    if(self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
    }
    
    //取消定时器
    if(self.fetchLocationTimer)
    {
        [self.fetchLocationTimer invalidate];
        self.fetchLocationTimer = nil;
    }
    
    //立即提交当前缓存的数据
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddhhmmss"];
    NSDate *now = [NSDate date];
    NSString *currentDate = [df stringFromDate:now];
    NSString *userId = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    [self commitUserLocation:userId beforeTime:currentDate];
}

- (void)commitUserLatitude:(NSString *)lat Longitude:(NSString *)lon
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMIT_PERSON_LOCATION" forKey:@"service"];
    [params setObject:[GUIDGenerator generateGUID] forKey:@"uuid"];
    [params setObject:lon forKey:@"lon"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@"gps" forKey:@"lctype"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    self.uploadConnection = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:nil delegate:self tagID:1];
}

- (void)commitUserLocation:(NSString *)uid beforeTime:(NSString *)time
{
    DLog(@"%@:正在提交数据", time);
    
    //记录当前操作的时间
    if(time != nil && time.length > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"COMMIT_GPS_DATA_TIME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //查询数据库获取数据
    int limitCount = 10;
    if ([SystemConfigContext sharedInstance].currentNetworkStatus == 1) {
        limitCount = 100;
    }
    NSArray *ary = [self.locationHelper queryUserLocation:uid fromTime:nil endTime:time count:limitCount];
    if(ary && ary.count > 0)
    {
        NSString *jsonString = [ary JSONString];
        DLog(@"本次提交%d条数据，提交的JSON数据:\n%@", ary.count, jsonString);
        
        NSMutableDictionary *params1 = [[NSMutableDictionary alloc] init];
        [params1 setObject:@"COMMIT_PERSON_LOCATION" forKey:@"service"];
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params1];
        
        NSMutableDictionary *params2 = [[NSMutableDictionary alloc] init];
        [params2 setObject:@"COMMIT_PERSON_LOCATION" forKey:@"service"];
        [params2 setObject:jsonString forKey:@"jsonString"];
        [params2 setObject:@"ALL" forKey:@"SCLX"];
        
        self.uploadConnection = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:nil delegate:self parameters:params2 tipInfo:nil tagID:2];
    }
}

- (void)removeUserLocation:(NSString *)uid beforeTime:(NSString *)time
{
    int limitCount = 10;
    if ([SystemConfigContext sharedInstance].currentNetworkStatus == 1) {
        limitCount = 100;
    }
    
    NSArray *l1 = [self.locationHelper queryUserLocation:uid];
    NSLog(@"开始有%d条数据", l1.count);
    BOOL ret = [self.locationHelper removeUserLocation:uid fromTime:nil endTime:time count:limitCount];
    NSArray *l2 = [self.locationHelper queryUserLocation:uid];
    NSLog(@"还剩下%d条数据", l2.count);
    if(ret)
    {
        NSLog(@"删除完成!");
    }
    else
    {
        NSLog(@"删除失败!");
    }
}

- (void)saveUserLocation:(NSString *)uid Latitude:(NSString *)lat Longitude:(NSString *)lon
{
    LocationItem *item = [[LocationItem alloc] init];
    item.userId = uid;
    item.lat = lat;
    item.lon = lon;
    item.lctype = @"gps";
    item.uuid = [GUIDGenerator generateGUID];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddhhmmss"];
    item.lctime = [df stringFromDate:[NSDate date]];
    item.imei = [[SystemConfigContext sharedInstance] getDeviceID];
    
    if(self.locationHelper == nil)
    {
        self.locationHelper = [[LocationHelper alloc] init];
    }
    [self.locationHelper addLocation:item];
}

#pragma mark - Private Methods

- (void)fetchUserLocationData
{
    NSString *gpsConfig = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingNightGPSConfig];
    if([gpsConfig isEqualToString:@"1"])
    {
        //夜间模式开启中,判断当前时间是不是在18:00-06:00
        if([self isNight])
        {
            DLog(@"当前开启夜间模式，停止定位");
            [self stopFetchLocation];
            return;
        }
    }
    
     
    if([CLLocationManager locationServicesEnabled])
    {
        if(self.locationManager == nil)
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 200.0f;
        }
        [self.locationManager startUpdatingLocation];
    }
    
    //判断当前时间是否是14:00或者是14:30这样的时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddhhmmss"];
    NSDate *now = [NSDate date];
    NSString *currentDate = [df stringFromDate:now];//140000
    NSString *currentTime = [currentDate substringWithRange:NSMakeRange(10, 2)];
    //每5分钟提交一次数据
    NSString *lastUploadTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"COMMIT_GPS_DATA_TIME"];
    NSString *lastTime = [lastUploadTime substringWithRange:NSMakeRange(10, 2)];
    if([currentTime intValue]%5 == 0 && ![lastTime isEqualToString:currentTime])
    {
        NSString *userId = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
        [self commitUserLocation:userId beforeTime:currentDate];
    }
}

- (BOOL)isNight
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentTime = [df stringFromDate:[NSDate date]];
    
    NSString *hour = [currentTime substringWithRange:NSMakeRange(8, 2)];
    if([hour intValue] >= 18)
    {
        return YES;
    }
    else if ([hour intValue] <= 6)
    {
        return YES;
    }
    return NO;
}

#pragma mark - CLLocationManager Delegate Method

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *lat = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    
    self.currentLon = lon;
    self.currentLat = lat;
    
    //停止当前定位
    [self.locationManager stopUpdatingLocation];
    
    //定时获取数据缓存，定期上传
    NSString *userId = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    [self saveUserLocation:userId Latitude:lat Longitude:lon];
    
    //实时上传用户位置
    //[self uploadLatitude:lat Longitude:lon];
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    if([error code] == kCLErrorDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务拒绝使用,请到系统隐私设置开启系统定位服务." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        //取消定时更新
        [self.fetchLocationTimer invalidate];
        self.fetchLocationTimer = nil;
        return;
    }
}

#pragma mark - Network Handler Method

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if(webData.length <= 0)
    {
        return;
    }
    
    if(tag == 2)
    {
        NSString *log = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [log objectFromJSONString];
        if(dict)
        {
            NSString *result = [dict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                //上传成功，清除数据
                DLog(@"上传成功");
                NSString *userId = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
                NSString *t = [[NSUserDefaults standardUserDefaults] objectForKey:@"COMMIT_GPS_DATA_TIME"];
                [self removeUserLocation:userId beforeTime:t];
            }
            else
            {
                //上传失败
                DLog(@"上传失败");
            }
        }
    }
    
}

- (void)processError:(NSError *)error andTag:(NSInteger)tag
{
    DLog(@"上传失败");
}

@end
