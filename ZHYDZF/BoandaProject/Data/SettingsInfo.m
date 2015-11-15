//
//  SettingsInfo.m
//  HNYDZF
//
//  Created by 张仁松 on 12-6-21.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SettingsInfo.h"

@implementation SettingsInfo
@synthesize ipHeader, supportInnerAccess;

#define  kServiceIpKey @"ip_preference1"
#define  kOAServiceIpKey @"ip_preference2"
#define  kSupportInnerAccessKey @"inner_preference"

+ (SettingsInfo *) sharedInstance
{
    static SettingsInfo *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedSingleton = [[SettingsInfo alloc] init];
    });
    return _sharedSingleton;
}

- (void)readPreference
{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kServiceIpKey];
	if (testValue == nil)
	{
		NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        if(!settingsBundle)
        {
            NSLog(@"Could not find Settings.bundle");
            return;
        }
        
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
        for(NSDictionary *prefSpecification in preferences)
        {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if(key)
            {
                [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to go, so lastly set the key preference values
	self.ipHeader = [[NSUserDefaults standardUserDefaults] stringForKey:kServiceIpKey];
    self.oaipHeader = [[NSUserDefaults standardUserDefaults] stringForKey:kOAServiceIpKey];
    self.supportInnerAccess = [[[NSUserDefaults standardUserDefaults] stringForKey:kSupportInnerAccessKey] boolValue];
     
}

- (void)readSettings
{
    [self readPreference];
}

@end


