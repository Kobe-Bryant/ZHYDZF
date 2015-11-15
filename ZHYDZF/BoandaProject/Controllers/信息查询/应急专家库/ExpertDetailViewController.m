//
//  ExpertDetailViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-15.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ExpertDetailViewController.h"
#import "ServiceUrlString.h"

@interface ExpertDetailViewController ()<UIWebViewDelegate>

@end

@implementation ExpertDetailViewController
@synthesize primaryKey;

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
	// Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DETAIL_CATEGORY_CONFIG" forKey:@"service"];
    [params setObject:@"hjxf/yjrkDataDetail.jsp" forKey:@"LINK"];
    [params setObject:primaryKey forKey:@"PRIMARY_KEY"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSURL *aUrl = [NSURL URLWithString:strUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:aUrl]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
