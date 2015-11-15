//
//  ZFTZChildRecordViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ZFTZChildRecordViewController.h"
#import "ServiceUrlString.h"

@interface ZFTZChildRecordViewController ()
@property (nonatomic, strong) UIWebView *myWebView;
@end

@implementation ZFTZChildRecordViewController
@synthesize myWebView;

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
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.myWebView.delegate = self;
    myWebView.scalesPageToFit = YES;
    [self.view addSubview:myWebView];
    
    if(self.recordId != nil && self.recordId.length > 0)
    {
        //动态表单
        [self requestDynamicFormData];
    }
    else
    {
        [self requestNormalFormData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取正常的表单的数据
- (void)requestNormalFormData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:self.primaryKey forKey:@"PRIMARY_KEY"];
    [params setObject:self.link forKey:@"LINK"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    NSLog(@"zhifataizhangstrUrl=%@",strUrl);
    NSURL *url = [NSURL URLWithString:strUrl];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

//获取动态表单的数据
- (void)requestDynamicFormData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZFBD" forKey:@"service"];
    [params setObject:self.templateId forKey:@"templateId"];
    [params setObject:self.recordId forKey:@"recordId"];
    [params setObject:self.primaryKey forKey:@"ZFBH"];
    [params setObject:@"" forKey:@"WRYBH"];//可为空
    [params setObject:@"ios" forKey:@"reqType"];
    [params setObject:@"1" forKey:@"view"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSURL *url = [NSURL URLWithString:strUrl];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
