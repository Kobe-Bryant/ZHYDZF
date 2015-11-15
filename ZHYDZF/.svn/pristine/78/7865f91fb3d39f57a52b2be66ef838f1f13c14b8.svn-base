//
//  ServiceUrlString.m
//  HNYDZF
//
//  Created by �? �???? on 12-6-21.
//  Copyright (c) 2012�? __MyCompanyName__. All rights reserved.
//
/*
 http://61.164.73.82:8090/ydzf/invoke?version=1.16&imei=DAFE9EA2-03D9-49AC-85E0-88AE1AF9D6DE&clientType=IPAD&userid=leying&password=123456&service=DOWN_OA_FILES&FJLX=.jpg&GLLX=DOWNLOAD_XCQZ_FILE&PATH=/WEB-INF/DataFile/20140731084225e52e7f8717354c359b4fa2c89ab289e0/Material\20140731085212.jpg&P_PAGESIZE=25
 2014-07-31 09:12:47.781 BoandaProject[3149:60b] KeyChain Item: <44414645 39454132 2d303344 392d3439 41432d38 3545302d 38384145 31414639 44364445>

*/

#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "OperateLogHelper.h"

@implementation ServiceUrlString
+(NSString*)generateUrlByParameters:(NSDictionary*)params{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
 
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    if(![aryKeys containsObject:@"P_PAGESIZE"]){
        [paramsStr appendFormat:@"&P_PAGESIZE=%d",ONE_PAGE_SIZE];
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
 
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/invoke?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",[context getSeviceHeader], [context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"],[loginUsr objectForKey:@"password"], paramsStr];
   // NSLog(@"strul===%@",strUrl);
//    NSLog(@"zzt---[context getDeviceID]:%@",[context getDeviceID]);
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    return modifiedUrl;
}

+ (NSString*)generateTingUrlByParameters:(NSDictionary*)params
{
    if(params == nil)
    {
        return @"";
    }
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)
    {
        return @"";
    }
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys)
    {
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
    //正式使用
    NSString *strUrl = [NSString stringWithFormat:@"https://%@/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@", [context getSeviceHeader],[context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"], [loginUsr objectForKey:@"password"], paramsStr];
    
    /*if (DEBUG) {
     //测试用 wujianping 28:6A:BA:4F:B3:93 123456
     strUrl = [NSString stringWithFormat:@"https://221.7.135.211/semop/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@", [context getAppVersion], @"28:6A:BA:4F:B3:93",@"wujianping", @"123456", paramsStr];
     }*/
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    DLog(@"厅请求的服务地址:%@", modifiedUrl);
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    return modifiedUrl;
}
@end
