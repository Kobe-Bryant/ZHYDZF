//
//  HJXFDetailViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "HJXFDetailViewController.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"

@interface HJXFDetailViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation HJXFDetailViewController

@synthesize webView;

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
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业信息目录列表
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG, 必选)
 * 参数2:LINK(对应前面污染源企业列表中的LINK字段, 必选)
 * 参数3:PRIMARY_KEY(污染源编号，对应前面污染源企业列表中的PRIMARY_KEY字段, 必选)
 */
- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self tagID:1];
}

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    
    if(detailDict != nil)
    {
     //   self.title = [detailDict objectForKey:@"GLOBAL_TITLE"];
        NSArray *ary = [detailDict objectForKey:@"data"];
        if(ary.count > 0)
        {
            NSString *subLink = [[ary objectAtIndex:0] objectForKey:@"LINK"];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
            [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
            [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
            [params setObject:subLink forKey:@"LINK"];
            NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
            NSURL *url = [NSURL URLWithString:strUrl];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
    
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

@end
