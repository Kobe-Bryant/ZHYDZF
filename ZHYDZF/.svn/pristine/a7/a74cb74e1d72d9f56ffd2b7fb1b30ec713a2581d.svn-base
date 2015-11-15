//
//  XZCFDetailsViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "XZCFDetailsViewController.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"

@interface XZCFDetailsViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation XZCFDetailsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业的档案的目录(需要手动设置下面3个参数)
 * 参数1:service(这里固定为DETAIL_CATEGORY_CONFIG)
 * 参数2:LINK(执行的路径,对应从前面带过来的LINK)
 * 参数3:PRIMARY_KEY(污染源编号,从前面带过来的)
 */
- (void)requestData
{
    self.isLoading = YES;
    //获取污染源企业档案目录
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.link forKey:@"LINK"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    NSString *UrlStr = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = UrlStr;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
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
        self.title = [detailDict objectForKey:@"GLOBAL_TITLE"];
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
