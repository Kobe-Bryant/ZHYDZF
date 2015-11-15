//
//  DynamicRecordViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-17.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//
/*
 service=LIST_WRY_ZFBD&WRYBH=310000000000201300250&TYPE=1&ZFBH=1#
 获取污染源对应的表单模板
 */

/* 获取动态表单模板id
 QUERY_ZFBD_URL
 [{"MBBH":"20130723110501b6feb85b3c2e426d925b884e7ad8295d","MBMC":"污染源现场监察记录表_餐饮娱乐SH"},{"MBBH":"201308161727203dbabae3fb454215849376fa07b43c85","MBMC":"铅蓄电池检查表"},{"MBBH":"2013082815162662fd52da9c19402b9f2611775a8d5a27","MBMC":"上海市现场检查记录"},}
 */
/* 
 组合动态表单url：
 service:QUERY_ZFBD
 参数：ZFBH、recordId、templateId、&reqType=android
view=1是否能编辑，否
 loadAll=true加载完整表单
 WRYBH
 ZFBM：登录人所在部门
 */
/* 提交数据：
 OPERATE_ZFBD
 "javascript:fillJwd('"+s1+"','"+s2+"','"+locPoint.x+"','"+locPoint.y+"')
javascript:fetchTempData()");//暂存数据 
 "javascript:fillUserOrDepartment('"+typeId+"','"+USER_IDS+"','"+USER_NAMES+"')"
 */

#import "DynamicRecordViewController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "AHAlertView.h"
#import "ASIFormDataRequest.h"
#import "PrintPreviewViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RecordsHelper.h"
#import "PersonChooseVC.h"

@interface DynamicRecordViewController ()<UIWebViewDelegate,PersonChooseResult>
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong) ASIFormDataRequest *request;
@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,strong)NSString *historyRecordID;
@property(nonatomic,strong)UIPopoverController *popPersonController;
@property(nonatomic,strong)NSString *jsUserTypeID;
@end

@implementation DynamicRecordViewController
@synthesize webView,templateid,HUD,request,historyRecordID,jsUserTypeID;

@synthesize javascriptBridge = _bridge;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableName = @"T_YDZF_DTBD";
    }
    return self;
}

-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
    if (values == nil) {
		[self.navigationController popViewControllerAnimated:NO];
	}
	else {
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.wrymc = self.title = [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
        }
        else
        {
            self.dwbh     = [values objectForKey:@"WRYBH"];
            self.wrymc = self.title =  [values objectForKey:@"WRYMC"];
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
        }
        [self  queryXCZFBH];
        bOutSide = bOut;
        [super returnSites:values outsideComp:bOutSide];
	}
}

-(void)xczfbhHasGenerated{
    [self loadDTBDInfo];
}

-(void)requestHistoryData{
    [super requestHistoryData];
   
    
}

-(void)displayHistoryRecord{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZFBD" forKey:@"service"];
    [params setObject:templateid forKey:@"templateId"];
    
    
    [params setObject:self.basebh forKey:@"recordId"];
    
    
    [params setObject:@"ios" forKey:@"reqType"];
    [params setObject:@"true" forKey:@"loadAll"];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [params setObject:[userInfo objectForKey:@"depart"] forKey:@"ZFBM"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)loadDTBDInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"LIST_WRY_ZFBD" forKey:@"service"];
    [params setObject:self.dwbh forKey:@"WRYBH"];
    [params setObject:self.xczfbh forKey:@"ZFBH"];
    [params setObject:@"1" forKey:@"TYPE"];
    //TYPE=1表示上海
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"正在获取动态表单数据..." tagID:LIST_WRY_ZFBD] ;
}

-(void)loadDTBDView{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在加载动态表单...";
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZFBD" forKey:@"service"];
    [params setObject:templateid forKey:@"templateId"];
    [params setObject:self.xczfbh forKey:@"ZFBH"];
    if([self.basebh length] > 0)
        [params setObject:self.basebh forKey:@"recordId"];
    else
        [params setObject:@"" forKey:@"recordId"];
    [params setObject:self.dwbh forKey:@"WRYBH"];
    
    [params setObject:@"ios" forKey:@"reqType"];
    [params setObject:@"true" forKey:@"loadAll"];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [params setObject:[userInfo objectForKey:@"depart"] forKey:@"ZFBM"];
    [params setObject:[userInfo objectForKey:@"uname"] forKey:@"JCR"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 704)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self  handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"showMsg" handler:^(id data, WVJBResponseCallback responseCallback) {
       [self showAlertMessage:data];
    }];

    [_bridge registerHandler:@"saveData" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self saveDataFromJSP:data];
    }];
    
    
    [_bridge registerHandler:@"saveTempData" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self saveTempDataFromJSP:data];
    }];
    
    [_bridge registerHandler:@"chooseUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dicData = (NSDictionary *)(data);
        if(dicData)
                [self chooseUser:[dicData objectForKey:@"type"] andTypeID:[dicData objectForKey:@"id"]];
        else
             NSLog(@"chooseUser error:%@",data);
    }];
    if(self.isHisRecord){
        [self displayHistoryRecord];
    }
}


//jsp页面调用此函数
-(void)saveDataFromJSP:(id)data{
//    NSLog(@"saveDataFromJSP :%@",data);
}

//jsp页面调用此函数,暂存
-(void)saveTempDataFromJSP:(id)data{
//     NSLog(@"saveTempDataFromJSP :%@",data);
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

-(void)commitBilu:(id)sender
{
     [self commitRecordDatas:nil];

}

//(MBBH   VARCHAR(200),ZFBH  VARCHAR(200),ZFSJ  VARCHAR(4000),WRYBH    VARCHAR(100), WRYMC    varchar2(200));
-(void)saveBilu:(id)sender{
    [super saveBilu:sender];
    [_bridge callHandler:@"fetchTempData" data:nil responseCallback:^(id response) {
        
        NSLog(@"fetchTempData responded: %@", response);
        NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithCapacity:5];
        [dicValue setObject:self.dwbh forKey:@"WRYBH"];
        [dicValue setObject:self.wrymc forKey:@"WRYMC"];
        [dicValue setObject:self.templateid forKey:@"MBBH"];
        [dicValue setValue:self.xczfbh forKey:@"XCZFBH"];
        [dicValue setValue:self.basebh forKey:@"BH"];
        [dicValue setValue:response forKey:@"ZFSJ"];
        [self saveLocalRecord:dicValue];
    }];
}

//提交数据到对应的笔录表中

-(void)commitRecordDatas:(NSDictionary*)value{
    

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在提交动态表单数据...";
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"OPERATE_ZFBD" forKey:@"service"];
    [params setObject:@"save" forKey:@"operate"];
    [params setObject:templateid forKey:@"templateId"];
    [params setObject:self.xczfbh forKey:@"ZFBH"];
    [params setObject:self.dwbh forKey:@"WRYBH"];
    [params setObject:self.basebh forKey:@"recordId"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    [ request addPostValue :[loginUsr objectForKey:@"userId"] forKey :@"userid"];
    [ request addPostValue :[loginUsr objectForKey:@"password"]forKey :@"password"];
    [ request addPostValue :[context getDeviceID] forKey :@"imei"];
    [ request addPostValue :[context getAppVersion]  forKey :@"version"];


    [request addPostValue:@"OPERATE_ZFBD" forKey:@"service"];
    [request addPostValue:@"save" forKey:@"operate"];
    [request addPostValue:templateid forKey:@"templateId"];
    [request addPostValue:self.xczfbh forKey:@"ZFBH"];
    [request addPostValue:self.dwbh forKey:@"WRYBH"];
    [request addPostValue:self.basebh forKey:@"recordId"];
    
   
    [_bridge callHandler:@"fetchData" data:nil responseCallback:^(id response) {
        
        NSLog(@"fetchData responded: %@", response);
        NSArray *ary = [response objectFromJSONString];
        for(NSDictionary *dicItem in ary){
            [request addPostValue:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
            
           // [params setObject:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
            
        }
        /*
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        NSLog(@"strUrl:%d %@",[strUrl length],strUrl);
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"正在提交动态表单数据..." tagID:OPERATE_ZFBD] ;*/
        
        [self.request setDelegate:self ];
        
        [self.request setDidFinishSelector:@selector(responseComplete)];
        [self.request setDidFailSelector:@selector(responseFailed)];
        [self.request startAsynchronous];
        
    }];
}


-(void)responseFailed{
    [HUD hide:YES];
    [HUD removeFromSuperview];
}
-( void )responseComplete
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    NSString *resultJSON = self.request.responseString;
    NSDictionary *dicResult = [resultJSON objectFromJSONString];
    if(dicResult && [[dicResult objectForKey:@"result"] isEqualToString:@"true"])
    {
        
        
         NSDictionary *baseTableJson = [self createBaseTableFromWryData:nil];
         
         [self commitBaseRecordData:baseTableJson];
        
        //删除未提交笔录中暂存的数据
        RecordsHelper *helper = [[RecordsHelper alloc] init];
        [helper deleteRecordByBH:self.basebh andTableName:self.tableName];
        
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"提示" message:@"笔录提交成功！"];
        
        [alert setCancelButtonTitle:@"确定" block:^{
            self.recordStatus = Record_Commited_Success;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addButtonWithTitle:@"打印预览"  block:^{
            self.recordStatus = Record_Commited_Success;
            [self printPreview];
        }];
        [alert show];
        
       
        
        
    }
    else{
        
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"笔录提交失败！"];
        
        [alert setCancelButtonTitle:@"确定" block:^{
            self.recordStatus = Record_Commited_Success;
        }];
        
        [alert show];
    }
    
}
-(void)displayRecordDatas:(NSDictionary*)object{
    if(self.displayFromLocal){
        NSString *jsonStr = [object objectForKey:@"ZFSJ"];
        NSMutableString *modifyStr = [NSMutableString stringWithString:jsonStr];
        //去掉tab 和 \r\n键
        [modifyStr replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
        [modifyStr replaceOccurrencesOfString:@"\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
        NSLog(@"displayRecordDatas:(ZFSJ):%@",modifyStr);
        NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithCapacity:3];
        [dicData setObject:[modifyStr objectFromJSONString] forKey:@"data"];
        //此处注意：data不应该传字符串，应该传对象
        [dicData setObject:[object objectForKey:@"MBBH"] forKey:@"templateId"];
        [dicData setObject:@"1234" forKey:@"recordId"];
        
        [_bridge callHandler:@"renderData" data:dicData responseCallback:^(id response) {
            
            NSLog(@"renderData123:%@",response);
            
        }];
    }else{
        self.historyRecordID = [object objectForKey:@"RECORDID"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"QUERY_ZFBD_TEMPLATE_LIST" forKey:@"service"];
        [params setObject:self.dwbh forKey:@"wrybh"];
        [params setObject:self.templateid forKey:@"templateId"];
        
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"正在获取相关数据..." tagID:QUERY_ZFBD_TEMPLATE_LIST] ;
    }
    
}

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    [dicParams setObject:self.dwbh forKey:@"WRYBH"];
    
    [dicParams setObject:self.wrymc    forKey:@"WRYMC"];
    
    return dicParams;
}

//[{"MBBH":"2013082815162662fd52da9c19402b9f2611775a8d5a27","MBMC":"上海市现场检查记录","SIZE":0}]
-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if(tag != LIST_WRY_ZFBD && tag!= OPERATE_ZFBD &&tag!=QUERY_ZFBD_TEMPLATE_LIST)
        return [super processWebData:webData andTag:tag];
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bfailed = YES;
    if(tag == LIST_WRY_ZFBD){
        NSArray *aryResult = [resultJSON objectFromJSONString];
        if(aryResult && [aryResult count])
        {
            NSDictionary *dic = [aryResult objectAtIndex:0];
            if(dic){
                self.templateid = [dic objectForKey:@"MBBH"];
                bfailed = NO;
                [self loadDTBDView];
            }
        }
        if(bfailed )
        {
            NSString *msg = @"没有查询到该污染源的动态表单。";
            [self showAlertMessage:msg];
            
        }
    }
    else if(QUERY_ZFBD_TEMPLATE_LIST){
        NSDictionary *dicResult = [resultJSON objectFromJSONString];
        NSArray *aryTmp = [dicResult objectForKey:@"data"];
        if(dicResult && [aryTmp count] > 0){
            NSMutableString *yszIDs = [NSMutableString stringWithCapacity:100];
            for(NSDictionary *dicItem in aryTmp){
                if ([yszIDs length] > 0) {
                    [yszIDs appendFormat:@"#%@",[dicItem objectForKey:@"YSZBH"]];
                }else{
                    [yszIDs appendFormat:@"%@",[dicItem objectForKey:@"YSZBH"]];
                }
            }
            //yszIds 已经选择的tab页
            NSDictionary *dicData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:templateid,self.historyRecordID,yszIDs, nil] forKeys:[NSArray arrayWithObjects:@"templateId",@"recordId",@"yszIds", nil]];
            [_bridge callHandler:@"fetchHistoryData" data:dicData responseCallback:^(id response) {
                
               
                
            }];
        }
        
    }
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView{
    if(HUD)  [HUD hide:YES];
    [HUD removeFromSuperview];
  //  [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'"];
    
    
}

-(void)printPreview{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:@"QUERY_ZFBD_PRINT" forKey:@"service"];
    [params setObject:self.templateid forKey:@"templateId"];
    [params setObject:self.basebh forKey:@"recordId"];
    [params setObject:self.xczfbh forKey:@"ZFBH"];
    [params setObject:@"ios" forKey:@"reqType"];
    [params setObject:@"5" forKey:@"view"];
    [params setObject:self.dwbh forKey:@"WRYBH"];
    [params setObject:@"" forKey:@"ZFBM"];
   
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    PrintPreviewViewController *controller = [[PrintPreviewViewController alloc] init];
    controller.printUrl = strUrl;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
