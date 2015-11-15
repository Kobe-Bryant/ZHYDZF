//
//  WebserviceHelper.h
//  tesgt
//
//  Created by 曾静 on 12-1-7.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface NSURLConnHelper : NSObject{
    NSInteger tagID;
}

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, assign) id<NSURLConnHelperDelegate> delegate;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSURLConnection *mConnection;

@property (nonatomic, assign) BOOL needCached;//是否需要缓存数据
@property (nonatomic, assign) NSInteger expiredTime;//缓存过期时间

-(void)cancel;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                        delegate:(id)aDelegate
                          tagID:(NSInteger)tag;//用来区分不同的服务请求,赋值要大于0

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate
                        tipInfo:(NSString*)tip //hud上显示的文字
                          tagID:(NSInteger)tag; //用来区分不同的服务请求,赋值要大于0

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                      parameters:(NSDictionary *)params
                         tipInfo:(NSString*)tip //hud上显示的文字
                           tagID:(NSInteger)tag;

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                         tipInfo:(NSString *)tip
                           tagID:(NSInteger)tag
                      needCached:(BOOL)cache
                     expiredTime:(NSInteger)aTime;

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                  postParameters:(NSDictionary *)params
                         tipInfo:(NSString*)tip //hud上显示的文字
                           tagID:(NSInteger)tag;

@end
