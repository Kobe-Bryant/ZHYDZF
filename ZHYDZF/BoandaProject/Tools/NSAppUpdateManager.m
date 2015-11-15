//
//  NSAppUpdateManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NSAppUpdateManager.h"
#import "PDJsonkit.h"

@implementation NSAppUpdateManager

-(void)gotoSafari{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {

        [self gotoSafari];
    }
}

-(void)showTip:(NSString*)flag{
    if ([flag isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本，请更新。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本，是否更新？"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:@"取消",nil];
        [alert show];
        return;
    }
}

-(void)newVertionFound:(NSNotification *)note{
    NSString *flag = [[note userInfo] objectForKey:@"mustUpdate"];
    if (!_isUpdate) {
        
        [self performSelectorOnMainThread:@selector(showTip:) withObject:flag waitUntilDone:YES];
        _isUpdate = !_isUpdate;
    }
}

#define kNewVertionFound      @"kNewVertionFound"

-(void)checkAndUpdate:(NSString*)versionUrl{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newVertionFound:)
                                                 name:kNewVertionFound
                                               object:nil];
    [NSThread detachNewThreadSelector:@selector(checkVersion:) toTarget:self withObject:versionUrl];
}
-(void)checkVersion:(NSString*)versionUrl{
 
    NSURL *url = [NSURL URLWithString:versionUrl];
    
    NSString *resultJSON = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *verInfo = [resultJSON objectFromJSONString];
    NSString *serverVer = [verInfo objectForKey:@"version"];
    NSString *mustUpdate = [verInfo objectForKey:@"mustupdate"];
    CGFloat verFromServer = [serverVer floatValue] *100;
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CGFloat appVer = [settingVer floatValue] *100;
    if (verFromServer > appVer) {
    
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kNewVertionFound object:nil userInfo:[NSDictionary dictionaryWithObject:mustUpdate forKey:@"mustUpdate"]];
    }
    
}
@end
