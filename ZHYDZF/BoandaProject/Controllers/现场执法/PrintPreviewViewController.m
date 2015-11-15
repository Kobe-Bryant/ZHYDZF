//
//  PrintPreviewViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-11-27.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PrintPreviewViewController.h"
#import "MBProgressHUD.h"

@interface PrintPreviewViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation PrintPreviewViewController
@synthesize webView,printUrl,HUD;
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
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在加载打印数据...";
    [HUD show:YES];
    
    NSURL *url = [[NSURL alloc] initWithString:printUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView{
    if(HUD)  [HUD hide:YES];
    [HUD removeFromSuperview];
}

@end
