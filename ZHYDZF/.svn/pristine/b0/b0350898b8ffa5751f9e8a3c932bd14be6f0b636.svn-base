//
//  Html5BaseViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 14-2-25.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "Html5BaseViewController.h"

#import "PersonChooseVC.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "AHAlertView.h"
#import "SystemConfigContext.h"
#import "QueryHPSPProjectViewController.h"


@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
    
    
}
@end

@interface Html5BaseViewController ()<UIWebViewDelegate,PersonChooseResult>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *jsUserTypeID;

@property(nonatomic,strong)UIPopoverController *popPersonController;

@end

@implementation Html5BaseViewController
@synthesize htmlFileName,webView;
@synthesize javascriptBridge = _bridge;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"htm" inDirectory:@"html5"];
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self  handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"chooseUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"chooseUser called");
        NSDictionary *dicData = (NSDictionary *)(data);
        if(dicData)
            [self chooseUser:[dicData objectForKey:@"type"] andTypeID:[dicData objectForKey:@"id"]];
        else
            NSLog(@"chooseUser error:%@",data);
    }];
    
    [_bridge registerHandler:@"queryHuanPing" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"queryHuanPing called");
        QueryHPSPProjectViewController *formViewController = [[QueryHPSPProjectViewController alloc] initWithNibName:@"QueryHPSPProjectViewController" bundle:nil];
        formViewController.title = self.wrymc;
        formViewController.wrybh = self.dwbh;
        //[formViewController setDelegate:self];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
        nav.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self presentModalViewController:nav animated:YES];
       
    }];
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    webView.frame = self.view.bounds;
}

//type==1 单选 type==2多选
//typeID在fillUserOrDepartment 时候使用
-(void)chooseUser:(NSString*)type andTypeID:(NSString*)typeID{
    NSLog(@"chooseUser %@ :andTypeID %@",type,typeID);
    self.jsUserTypeID = typeID;
    PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
    
	controller.delegate = self;
    controller.multiUsers = YES;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popPersonController = popover;
    
	[popover presentPopoverFromRect:CGRectMake(200, 200, 100, 100) inView:webView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)personChoosed:(NSArray*)aryChoosed{
    
    
    [self.popPersonController dismissPopoverAnimated:YES];
    NSMutableString *strSLRName = [NSMutableString stringWithCapacity:20];
    NSMutableString *strYHID = [NSMutableString stringWithCapacity:20];
    NSMutableString *strZFZH = [NSMutableString stringWithCapacity:20];
    for(NSDictionary *dicPerson in aryChoosed){
        NSString * yhid = [dicPerson objectForKey:@"YHID"];
        NSString * zfzh = [dicPerson objectForKey:@"ZFZH"];
        NSString * yhmc = [dicPerson objectForKey:@"YHMC"];
        
        if([strSLRName length] == 0){
            
            [strSLRName appendString:yhmc];
            [strYHID appendString:yhid];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strZFZH appendString:zfzh];
            
            
        }else{
            [strSLRName appendFormat:@",%@",[dicPerson objectForKey:@"YHMC"]];
            [strYHID appendFormat:@",%@",yhid];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strZFZH appendFormat:@",%@",zfzh];
            
            
        }
        
    }
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicData setObject:self.jsUserTypeID forKey:@"id"];
    //此处注意：data不应该传字符串，应该传对象
    [dicData setObject:strYHID forKey:@"userId"];
    [dicData setObject:strSLRName forKey:@"userName"];
    [dicData setObject:strZFZH forKey:@"zfzh"];
    
    [_bridge callHandler:@"fillUserOrDepartmentOrZfzh" data:dicData responseCallback:^(id response) {
        
        NSLog(@"fillUserOrDepartmentOrZfzh:%@",response);
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}


-(NSDictionary*)getValueData{
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
    if(self.dicWryInfo)
        [dicParams setDictionary:self.dicWryInfo];
    [dicParams setObject:self.wrymc forKey:@"WRYMC"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
    [dicParams setObject:dateString forKey:@"CJSJ"];
    [dicParams setObject:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
    [dicParams setObject:dateString forKey:@"XGSJ"];
    [dicParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
    [dicParams setObject:@"手机" forKey:@"ZDLX"];
    [dicParams setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    [dicParams setObject:dateString forKey:@"JSSJ"];
    
    [dicParams setObject:self.xczfbh forKey:@"XCZFBH"];
    [dicParams setObject:self.basebh forKey:@"BH"];
    [dicParams setObject:self.dwbh forKey:@"WRYBH"];
    [_bridge callHandler:@"fetchTempData" data:nil responseCallback:^(id response) {
        
        NSLog(@"fetchTempData responded: %@", response);
        NSArray *ary = response;
        for(NSDictionary *dicItem in ary){
            [dicParams setObject:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
            
        }
        
        
    }];
    
    
    
    return dicParams;
}



-(void)displayRecordDatas:(NSDictionary*)object{
     
    

    [self fillDataToHtml:[self modifyDicValues:object]];
    
}

-(void)fillDataToHtml:(NSDictionary*)data{
    
    [_bridge callHandler:@"renderData" data:[data JSONString] responseCallback:^(id response) {
        
        NSLog(@"renderData123:%@",response);
        
    }];
}

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    [dicParams setObject:self.dwbh forKey:@"WRYBH"];
    
    [dicParams setObject:self.wrymc    forKey:@"WRYMC"];
    
    return dicParams;
}



-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView{
    
    //  [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'"];
    //去掉webView长按列表时的复制事件
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
}






@end
