//
//  SystemConfigContext.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SystemConfigContext.h"
#import "SettingsInfo.h"
#import "UsersHelper.h"
//#import "UIDevice+IdentifierAddition.h"
#import "SvUDIDTools.h"

@implementation SystemConfigContext

static NSMutableDictionary *config;
static SystemConfigContext *_sharedSingleton = nil;

+ (SystemConfigContext *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SystemConfigContext alloc] init];
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            config = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
    }
    
    return _sharedSingleton;
}

- (NSString *)getString:(NSString *)key
{
    return [config objectForKey:key];
}

- (NSArray *)getResultItems:(NSString *)key
{
    return [config objectForKey:key];
}

- (NSMutableDictionary *)getUserInfo
{
    return userInfo;
}

- (NSString *)getUserBMMC
{
    if (userInfo == Nil) {
        return @"";
    }
    NSString *bmmc = [userInfo objectForKey:@"BMMC"];
    if (bmmc == Nil) {
        UsersHelper *helper = [[UsersHelper alloc] init];
        bmmc = [helper queryBMMCByBMBH:[userInfo objectForKey:@"depart"]];
        if ([bmmc length] > 0) {
            [userInfo setObject:bmmc forKey:@"BMMC"];
        }
    }
    return bmmc;
}

- (void)setUser:(NSMutableDictionary *)userinfo
{
    userInfo = userinfo;
}

-(NSString*)getSeviceHeader{
    SettingsInfo   *settings = [SettingsInfo sharedInstance];
    if(ipflag == 0)
        return settings.ipHeader;
    else
        return settings.oaipHeader;
}

- (BOOL)isSupportInnerAccess
{
    SettingsInfo *settings = [SettingsInfo sharedInstance];
    return settings.supportInnerAccess;
}

- (NSString*)getAppVersion
{
     return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (NSString*)getDeviceID
{
    return [SvUDIDTools UDID];
}

- (void)readSettings
{
    [[SettingsInfo sharedInstance] readSettings];
}

- (NSArray*)getMenuConfigs
{
    return [config objectForKey:@"MenuItems"];
}

-(void)useOAIP:(BOOL)flag{
    if (flag)
        ipflag = 1;
    else
        ipflag = 0;
}

@end
