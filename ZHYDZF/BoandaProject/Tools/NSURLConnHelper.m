 //
//  WebserviceHelper.m
//  tesgt
//
//  Created by 曾静 on 12-1-7.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "NSURLConnHelper.h"
#import "SvUDIDTools.h"
#import "CacheManager.h"
#import "NSString+MD5.h"

@interface NSURLConnHelper ()

@property (nonatomic, strong) NSString *currentUrlToken;

@end

@implementation NSURLConnHelper
@synthesize webData,delegate,HUD,mConnection;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
{
    return  [self initWithUrl:aUrl
                andParentView:aView
                     delegate:aDelegate
                        tagID:0];
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl 
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                          tagID:(NSInteger)tag
{
    self = [super init]; 
    if (self) {
        self.delegate = aDelegate;
        tagID =tag;
        webData = [[NSMutableData alloc] initWithLength:100];

        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:180];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if (aView != nil) {
            
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = @"正在请求数据，请稍候...";
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
    return self;
    
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate
                        tipInfo:(NSString*)tip
                          tagID:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        self.delegate = aDelegate;
        tagID = tag;
        webData = [[NSMutableData alloc] initWithLength:100];
        
        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:180];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = tip;
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
    return self;
}

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                      parameters:(NSDictionary *)params
                         tipInfo:(NSString*)tip //hud上显示的文字
                           tagID:(NSInteger)tag
{
    if(self = [super init])
    {
        self.delegate = aDelegate;
        tagID = tag;
        webData = [[NSMutableData alloc] initWithLength:100];

        if (aView != nil)
        {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            HUD.labelText = tip;
            [HUD show:YES];
        }
        
        //url
        NSURL *nsurl = [NSURL URLWithString:aUrl];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsurl];
        
        //Content-Type
        [theRequest addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //HTTPMethod
        [theRequest setHTTPMethod:@"POST"];
        
        //HTTPBody
        NSArray *paramKeysAry = [params allKeys];        
        NSMutableData *bodyData = [[NSMutableData alloc] initWithCapacity:0];
        for (int i = 0; i < paramKeysAry.count; i++)
        {
            NSString *param = [paramKeysAry objectAtIndex:i];
            if(i == paramKeysAry.count - 1)
            {
                NSString *v1 = [self convertToUTF8Encoding:[params objectForKey:param]];
                NSString *s1 = [NSString stringWithFormat:@"%@=%@", param, v1];
                [bodyData appendData:[s1 dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                NSString *v2 = [self convertToUTF8Encoding:[params objectForKey:param]];
                NSString *s2 = [NSString stringWithFormat:@"%@=%@&", param, v2];
                [bodyData appendData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
       
        [theRequest setHTTPBody:bodyData];
        
        //Content-Length
        NSString *msgLength = [NSString stringWithFormat:@"%d", [bodyData length]];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];

        self.mConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if(self.mConnection)
        {
            webData = [[NSMutableData alloc] initWithCapacity:0];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                         tipInfo:(NSString *)tip
                           tagID:(NSInteger)tag
                      needCached:(BOOL)cache
                     expiredTime:(NSInteger)aTime
{
    self = [super init];
    if(self)
    {
        self.delegate = aDelegate;
        tagID = tag;
        self.needCached = cache;
        self.expiredTime = aTime;
        webData = [[NSMutableData alloc] initWithLength:100];
        
        NSURL *url = [NSURL URLWithString:aUrl];
        self.currentUrlToken = [aUrl md5Encrypt];
        
        if(self.needCached)
        {
            DLog(@"支持缓存策略，检查是否存在缓存:%@", self.currentUrlToken);
            if([[CacheManager shared] valueForKey:self.currentUrlToken])
            {
                CacheObject *obj = [[CacheManager shared] valueForKey:self.currentUrlToken];
                DLog(@"指定缓存存在且暂未过期，从缓存中读取数据:%@", obj.data);
                NSString *resultJSON = [NSString stringWithFormat:@"%@", obj.data];
                
                NSData *cacheData = [resultJSON dataUsingEncoding:NSUTF8StringEncoding];
                if(self.delegate && [self.delegate respondsToSelector:@selector(processWebData:andTag:)])
                {
                    [self.delegate processWebData:cacheData andTag:tagID];
                }
                else if(delegate && [delegate respondsToSelector:@selector(processWebData:)])
                {
                    [self.delegate processWebData:cacheData];
                }
            }
            else
            {
                DLog(@"指定缓存不存在需要从网络获取!");
                NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:180];
                self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
            }
        }
        else
        {
            DLog(@"不支持缓存策略，直接从网络获取!");
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:180];
            self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }
    return self;
}

- (NSURLConnHelper *)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView *)aView
                        delegate:(id)aDelegate
                  postParameters:(NSDictionary *)params
                         tipInfo:(NSString*)tip //hud上显示的文字
                           tagID:(NSInteger)tag
{
    if(self = [super init])
    {
        self.delegate = aDelegate;
        tagID = tag;
        webData = [[NSMutableData alloc] initWithLength:100];
        
        if (aView != nil)
        {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = tip;
            [HUD show:YES];
        }
        
        //url
        NSURL *nsurl = [NSURL URLWithString:aUrl];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsurl];
        
        //Content-Type
        [theRequest addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //HTTPMethod
        [theRequest setHTTPMethod:@"POST"];
        
        //HTTPBody
        NSArray *paramKeysAry = [params allKeys];
        NSMutableData *bodyData = [[NSMutableData alloc] initWithCapacity:0];
        for (int i = 0; i < paramKeysAry.count; i++)
        {
            NSString *param = [paramKeysAry objectAtIndex:i];
            if(i == paramKeysAry.count - 1)
            {
                [bodyData appendData:[[NSString stringWithFormat:@"%@=%@n", param, [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [bodyData appendData:[[NSString stringWithFormat:@"%@=%@n&", param, [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [theRequest setHTTPBody:bodyData];
        
        //Content-Length
        NSString *msgLength = [NSString stringWithFormat:@"%d", [bodyData length]];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        self.mConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if(self.mConnection)
        {
            webData = [[NSMutableData alloc] initWithCapacity:0];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

- (void)cancel
{
    if(mConnection)
    {
        [mConnection cancel];
    }
    if(HUD)
    {
        [HUD hide:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction %@", error);
    if(HUD)
    {
        [HUD hide:YES];
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(delegate && [delegate respondsToSelector:@selector(processError:andTag:)])
    {
        [delegate processError:error andTag:tagID];
    }
    else if(delegate && [delegate respondsToSelector:@selector(processError:)])
    {
        [delegate processError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //缓存数据
    if(self.needCached)
    {
        if(self.expiredTime <= 0)
        {
            self.expiredTime = 1;
        }
        DLog(@"支持缓存策略，现将数据缓存,缓存失效时间是%d分钟后!", self.expiredTime);
        if(self.currentUrlToken)
        {
            NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
            [[CacheManager shared] setValue:resultJSON forKey:self.currentUrlToken expiredAfter:60*self.expiredTime];
        }
    }
    
    //通知处理
    if(delegate && [delegate respondsToSelector:@selector(processWebData:andTag:)])
    {
        [delegate processWebData:webData andTag:tagID];
    }
    else if(delegate && [delegate respondsToSelector:@selector(processWebData:)])
    {
        [delegate processWebData:webData];
    }
}

#pragma mark - NSURLConnection Delegate Method

//服务器上配置的是self-signed certificate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge previousFailureCount] == 0)
    {
        NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
        NSString *authMethod = [protectionSpace authenticationMethod];
        if(authMethod == NSURLAuthenticationMethodServerTrust)
        {
            [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[protectionSpace serverTrust]] forAuthenticationChallenge:challenge];
            
        }
    }
}

- (NSString *)convertToUTF8Encoding:(NSString *)s
{
     NSString *modifiedStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)s, nil, nil,kCFStringEncodingUTF8));
    return modifiedStr;
}

@end
