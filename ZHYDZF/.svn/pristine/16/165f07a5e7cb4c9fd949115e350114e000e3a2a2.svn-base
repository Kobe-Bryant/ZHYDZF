//
//  VideoMonitorVC.m
//  BoandaProject
//
//  Created by PowerData on 14-6-19.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "VideoMonitorVC.h"
#import "LiveViewController.h"

@interface VideoMonitorVC ()<UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic,assign) BOOL bRequestPro;
@end

@implementation VideoMonitorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"监控列表";
    
    self.bRequestPro = NO;
    
    // 加载页面
	[self.webView setDelegate:self];
	
    // LoginInfo
    //NSString *serverUrl = @"http://61.164.73.82:19190";
    NSString *serverUrl = @"http://42.4.32.70:80";
    NSString *username =  @"guest";
    NSString *password =  @"guest";
    
    // 中文的用户名需要用gb2312编码
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSString *requestHttp = [NSString stringWithFormat:@"%s%s%s=%s&%s=%s&%s=%d&%s=%d&%s=%d&%s=%d&%s=%s",
                             [serverUrl UTF8String], PLATFORM_LOGIN_BASEURL,
                             PLATFORM_LOGIN_USERNAME, [username cStringUsingEncoding:enc],
                             PLATFORM_LOGIN_PASSWORD, [password cStringUsingEncoding:enc],
                             PLATFORM_LOGIN_WIDTH, PLATFORM_WEB_WIDTH,
                             PLATFORM_LOGIN_HEIGHT, PLATFORM_WEB_HEIGHT,
                             PLATFORM_LOGIN_NETTYPE, 1,
                             PLATFORM_LOGIN_DECODERCAPBILITY, PLATFORM_DECODER_AVC264 | PLATFORM_DECODER_HIK264,
                             PLATFORM_LOGIN_VERSION, PLATFORM_VERSION
                             ];
    
	// 请求url
	NSURL *aURL = [NSURL URLWithString:requestHttp];
	if (aURL == nil)
	{
		NSLog(@"aURL == nil");
		return;
	}
    
    NSLog(@"aURL:%@", aURL);
	
	NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
	[self.webView loadRequest:aRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark webView delegate methods
// 开始请求
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.activity startAnimating];
	[self.webView setUserInteractionEnabled:NO];
	[UIApplication sharedApplication ].networkActivityIndicatorVisible = YES;
}

// 结束请求
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.activity stopAnimating];
    self.activity.hidden = YES;
	[self.webView setUserInteractionEnabled:YES];
	[UIApplication sharedApplication ].networkActivityIndicatorVisible = NO;
}

// 请求错误发生
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if (NSURLErrorCancelled == [error code])
	{
		return;
	}
    
	NSLog(@"webview request failed:%@", [error localizedDescription]);
	
	// 结束请求
	[self.activity stopAnimating];
    self.activity.hidden = YES;
	[self.webView setUserInteractionEnabled:YES];
	[UIApplication sharedApplication ].networkActivityIndicatorVisible = NO;
}

// 确认是否开始请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *absoluteUrl = [[request URL] absoluteString];
	NSRange range = {0, 7};
    
    NSLog(@"absoluteUrl:%@", absoluteUrl);
    
	if ([absoluteUrl compare:@"rtsp://" options:NSCaseInsensitiveSearch range:range] == NSOrderedSame)
	{
		[self performSelector:@selector(navigationToRealplayView:) withObject:absoluteUrl afterDelay:0.5];
		[self.webView goBack];
		return FALSE;
	}
	else
	{
		// do nothing
	}
	return TRUE;
}

#pragma mark -
#pragma mark self define methods
/*******************************************************************************
 Function:			navigationToRealplayView
 Description:		定向到播放界面
 Input:
 Output:
 Return:
 *******************************************************************************/
- (void) navigationToRealplayView:(NSString *)URL
{
	// 判断是否处于请求状态，是的话直接返回，避免重复请求
 	if (self.bRequestPro)
	{
		return;
	}
	self.bRequestPro = true;
    
	LiveViewController *realplayView = [[LiveViewController alloc] initWithNibName:@"LiveViewController"
                                                                            bundle:nil];
    
	realplayView.rtspUrl = URL;
	
	NSLog(@"rtsp url = %@", URL);
	[self.navigationController pushViewController:realplayView animated:YES];
    self.bRequestPro = NO;
}
@end
