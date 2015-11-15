//
//  SettingsInfo.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsInfo : NSObject

@property (strong, nonatomic) NSString *ipHeader;//内网IP
@property (assign, nonatomic) BOOL supportInnerAccess;//是否支持内网
@property (strong,nonatomic) NSString *oaipHeader; //移动办公使用 

+ (SettingsInfo *)sharedInstance;

- (void)readSettings;

@end
