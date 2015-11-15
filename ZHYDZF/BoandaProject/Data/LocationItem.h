//
//  LocationItem.h
//  BoandaProject
//
//  Created by Alex Jean on 13-7-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationItem : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lctime;
@property (nonatomic, copy) NSString *lctype;
@property (nonatomic, copy) NSString *imei;

@end
