//
//  SystemConfigContext.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigContext : NSObject
{
    //当前用户信息
    NSMutableDictionary *userInfo;
    NSInteger ipflag  ; //0 使用移动执法的后台地址，1使用移动办公的地址
}

@property (nonatomic, assign) int currentNetworkStatus;//当前网络连接状态 0 表示外网 1表示内网

+ (SystemConfigContext *)sharedInstance;

- (NSString *)getString:(NSString *)key;

- (NSArray *)getResultItems:(NSString *)key;

- (NSArray*)getMenuConfigs;

//userId password userName userDepartID
- (NSMutableDictionary *)getUserInfo;

- (void)setUser:(NSMutableDictionary *)userinfo;

- (NSString*)getSeviceHeader;//内网访问IP

- (BOOL)isSupportInnerAccess;//是否支持内网访问

- (NSString*)getAppVersion;

- (NSString*)getDeviceID;

- (void)readSettings;

- (NSString *)getUserBMMC;

-(void)useOAIP:(BOOL)flag;

@end
