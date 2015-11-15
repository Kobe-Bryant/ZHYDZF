//
//  GZDTDetailViewController.m
//  BoandaProject
//
//  Created by 周占通 on 14-5-5.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "GZDTDetailViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

@interface GZDTDetailViewController ()

@end

@implementation GZDTDetailViewController
@synthesize wzbh,isLoading,html;

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
    
    cWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [self.view addSubview:cWebView];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"GZDTNR_LIST" forKey:@"service"];

    [params setObject:self.wzbh forKey:@"wzbh"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strul===%@",strUrl);
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - 网络数据处理
-(void)processWebData:(NSData*)webData{

    isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    
    //解析JSON格式的数据
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    NSString *str = [[[[[[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"] componentsSeparatedByString:@"\",\""] objectAtIndex:0] componentsSeparatedByString:@"\":\""] objectAtIndex:1];
    str = [str substringToIndex:str.length - 2];
    str = [str stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"<BR//>"];
//    NSDictionary *tmpParsedJsonDic = [resultJSON objectFromJSONString];

    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0){
        
//        NSDictionary *dic = [tmpParsedJsonAry lastObject];
        /*
        NSString *htmlStr = [NSString stringWithFormat:@"<HTML>\
                             <HEAD>\
                             <TITLE></TITLE>\
                             </HEAD>\
                             <BODY>\
                              %@\
                             </BODY>\
                             </HTML>",str];*/
        self.html = str;
    }
    else{
    
        bParseError = YES;
    }
    
    if(bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"提示"  message:@"获取数据出错。"  delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    else{
    
        [cWebView loadHTMLString:self.html baseURL:nil];
    }
}
-(void)processError:(NSError *)error{

    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    return;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
