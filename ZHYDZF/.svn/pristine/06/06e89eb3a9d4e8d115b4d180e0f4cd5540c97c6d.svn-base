//
//  MenuSyncManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-11.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MenuSyncManager.h"
#import "PDJsonkit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ServiceUrlString.h"
#import "MenuHelper.h"


@implementation MenuSyncManager
@synthesize networkQueue;



- ( void )requestDone:(ASIHTTPRequest *)request
{
    //如果数据量很大 返回的xml 用########隔开
    
    NSDictionary *dicMenuData = [request.responseString objectFromJSONString];
    if(dicMenuData && [dicMenuData count]>0){
        MenuHelper *helper = [[MenuHelper alloc] init];
        
        NSArray *aryYhcd = [dicMenuData objectForKey:@"syncYhcds"];
        if([aryYhcd count])
            [helper processSyncYhcds:aryYhcd];
        NSArray *aryAllMenus = [dicMenuData objectForKey:@"allMenus"];
        if([aryAllMenus count])
            [helper processAllMenus:aryAllMenus];
         [[NSNotificationCenter  defaultCenter] postNotificationName:kMenuSyncFinished object:self];
    }else{
        [[NSNotificationCenter  defaultCenter] postNotificationName:kMenuSyncFailed object:self];
    }
   
    
    
    
       
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
     [[NSNotificationCenter  defaultCenter] postNotificationName:kMenuSyncFailed object:self];
}



-(BOOL)syncMenus{
       

    //////////////////////////// 任务队列 /////////////////////////////
    if (! networkQueue ) {
        self.networkQueue = [[ ASINetworkQueue alloc ] init ];
    }

    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"USER_MENUS_DATA" forKey:@"service"];

    ASIHTTPRequest *request;
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    request = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :strUrl]];
    [request setDelegate:self];
    [request setDidFinishSelector: @selector (requestDone:)];
    [request setDidFailSelector: @selector (requestWentWrong:)];
    [ networkQueue addOperation :request];
        
   
    [networkQueue go ]; // 队列任务开始
    return YES;
}



-(void)cancel
{
    if(networkQueue)
        [self.networkQueue cancelAllOperations];
}

@end
