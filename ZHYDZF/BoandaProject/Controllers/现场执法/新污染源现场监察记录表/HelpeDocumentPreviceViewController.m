//
//  HelpeDocumentPreviceViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-10.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "HelpeDocumentPreviceViewController.h"

@interface HelpeDocumentPreviceViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *docWebView;

@end

@implementation HelpeDocumentPreviceViewController

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(onCloseClicked:)];
    self.navigationItem.rightBarButtonItem = closeBtn;
    
    if(self.docTitle)
    {
        self.title = self.docTitle;
    }
    else
    {
        self.title = @"查看文档";
    }
    
    NSLog(@"self.docName-----%@",self.docName);
    NSString *docPath = [[NSBundle mainBundle] pathForResource:self.docName ofType:@"doc"];
    if(docPath  && docPath.length > 0)
    {
        self.docWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        self.docWebView.delegate = self;
        [self.view addSubview:self.docWebView];
        
        //加载文件
        [self.docWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:docPath]]];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
    
- (void)onCloseClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
