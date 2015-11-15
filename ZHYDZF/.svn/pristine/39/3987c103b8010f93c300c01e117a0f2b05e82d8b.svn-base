//
//  TestRecordViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 14-2-25.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "TestRecordViewController.h"
#import "SystemConfigContext.h"
#import "AHAlertView.h"
#import "UsersHelper.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "ASIFormDataRequest.h"
#import "RecordsHelper.h"
#import "GUIDGenerator.h"


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

@interface TestRecordViewController ()
@property(nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic, strong) ASIFormDataRequest *request;
@end

@implementation TestRecordViewController
@synthesize HUD,request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableName = @"T_YDZF_XCKCBL";
        self.htmlFileName = @"wryxcjcjl";
    }
    return self;
}

-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
	if (values == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:values];
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.wrymc = self.title =  [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
        }
        else
        {
            self.dwbh     = [values objectForKey:@"WRYBH"];
            self.wrymc = self.title =     [values objectForKey:@"WRYMC"];
            
            
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.dicWryInfo = values;
            
            
            
        }
        NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        
        [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"JLR"] ;
        [dicParams setObject:self.wrymc forKey:@"KCDWFDMC"] ;
        UsersHelper *helper =[[UsersHelper alloc] init];
        NSString *sjqx = [userInfo objectForKey:@"sjqx"];
        NSString *dwmc = [helper queryHBJMCBySJQX:sjqx];
        if(dwmc.length > 0)
            [dicParams setObject:dwmc forKey:@"HBBM"] ;
        if([dicParams objectForKey:@"DWDZ"])
            [dicParams setObject:[dicParams objectForKey:@"DWDZ"] forKey:@"WRYDZ"] ;
        if([dicParams objectForKey:@"HBLXR"])
            [dicParams setObject:[dicParams objectForKey:@"HBLXR"] forKey:@"HBFZR"] ;
        
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
         [self fillDataToHtml:dicParams];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if(tag != COMIT_BL_XCKCBL && tag != QUERY_XCKCBL_HISTORY)
        return [super processWebData:webData andTag:tag];
    if( [webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (tag == COMIT_BL_XCKCBL) {
        NSRange result = [resultJSON rangeOfString:@"success"];
        
        if ( result.location!= NSNotFound) {
            
            NSDictionary *dicValue = [self getValueData];
            
            
            NSDictionary *baseTableJson = [self createBaseTableFromWryData:dicValue];
            
            [self commitBaseRecordData:baseTableJson];
            
            
            return;
        }
        else{
            
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"笔录提交失败！"];
            
            [alert setCancelButtonTitle:@"确定" block:^{
                
            }];
            [alert setTitleTextAttributes:[AHAlertView textAttributesWithFont:[UIFont boldSystemFontOfSize:18]
                                                              foregroundColor:[UIColor redColor]
                                                                  shadowColor:[UIColor redColor]
                                                                 shadowOffset:CGSizeMake(0, -1)]];
            
            [alert setMessageTextAttributes:[AHAlertView textAttributesWithFont:[UIFont systemFontOfSize:14]
                                                                foregroundColor:[UIColor redColor]
                                                                    shadowColor:[UIColor redColor]
                                                                   shadowOffset:CGSizeMake(0, -1)]];
            [alert show];
            
        }
    }
    else if (tag == QUERY_XCKCBL_HISTORY) {
        
        NSLog(@"%@",resultJSON);
        NSDictionary *dicInfo = [resultJSON objectFromJSONString];
        if(dicInfo){
            NSArray *ary = [dicInfo objectForKey:@"data"];
            if ([ary count] > 0) {
                NSDictionary *dicRecordData = [ary objectAtIndex:0];
                [self displayRecordDatas:dicRecordData];
            }
        }
    }
    
}

-(void)processError:(NSError *)error{
    
}

-(void)xczfbhHasGenerated{
    
}


-(void)commitBilu:(id)sender
{
    [self commitRecordDatas:nil];
    
}

//(MBBH   VARCHAR(200),ZFBH  VARCHAR(200),ZFSJ  VARCHAR(4000),WRYBH    VARCHAR(100), WRYMC    varchar2(200));
-(void)saveBilu:(id)sender{
    [super saveBilu:sender];
    [self.javascriptBridge callHandler:@"fetchData" data:nil responseCallback:^(id response) {
        
        NSLog(@"fetchData responded: %@", response);
        NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithCapacity:5];
        [dicValue setObject:self.dwbh forKey:@"WRYBH"];
        [dicValue setObject:self.wrymc forKey:@"WRYMC"];
        [dicValue setValue:self.xczfbh forKey:@"XCZFBH"];
        [dicValue setValue:self.basebh forKey:@"BH"];
        [dicValue setValue:response forKey:@"ZFSJ"];
        [self saveLocalRecord:dicValue];
    }];
}

//提交数据到对应的笔录表中
-(void)commitRecordDatas:(NSDictionary*)value{
    
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在提交动态表单数据...";
    [HUD show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"COMMIT_BL_WRYXCJCJL" forKey:@"service"];

    
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
    
    
    [request addPostValue:@"COMMIT_BL_WRYXCJCJL" forKey:@"service"];
   
    
    
    [self.javascriptBridge callHandler:@"fetchData" data:nil responseCallback:^(id response) {
         if([response length] == 0)
             return ;
        
        NSLog(@"fetchData responded: %@", response);
        NSDictionary *dicData = [response objectFromJSONString];
        
        NSDictionary *aryJsonString = [dicData objectForKey:@"jsonString"];
        NSMutableDictionary *jsonStrParams = [NSMutableDictionary dictionaryWithCapacity:10];
        if(self.dicWryInfo)
            [jsonStrParams setDictionary:self.dicWryInfo];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        
        [jsonStrParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
        [jsonStrParams setObject:dateString forKey:@"CJSJ"];
        [jsonStrParams setObject:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
        [jsonStrParams setObject:dateString forKey:@"XGSJ"];
        [jsonStrParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
        [jsonStrParams setObject:@"ipad" forKey:@"ZDLX"];
        [jsonStrParams setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
        [jsonStrParams setObject:dateString forKey:@"JSSJ"];
        
        [jsonStrParams setObject:self.xczfbh forKey:@"XCZFBH"];
        [jsonStrParams setObject:self.basebh forKey:@"BH"];
        [jsonStrParams setObject:self.dwbh forKey:@"WRYBH"];
        
        [jsonStrParams setObject:self.wrymc forKey:@"WRYMC"];
        
        for(NSDictionary *dicItem in aryJsonString){
             [jsonStrParams setObject:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
            
        }

        NSArray *aryXjxm = [dicData objectForKey:@"xjxmString"];
        if( [aryXjxm isKindOfClass:[NSArray class]]&& [aryXjxm count] > 0){
            //来组合数据，新建项目放在一个数组里面
            NSMutableArray *aryXJXMResult = [NSMutableArray arrayWithCapacity:3];
            for(NSArray *aryChild in aryXjxm){
                NSMutableDictionary *xjxmParams = [NSMutableDictionary dictionaryWithCapacity:5];
                NSString *xjxmBh =  [GUIDGenerator generateGUID];
                [xjxmParams setValue:xjxmBh forKey:@"BH"];
                [xjxmParams setValue:self.basebh forKey:@"XCJCBH"];
                for(NSDictionary *dicItem in aryChild){
                    [xjxmParams setObject:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
                }
                [aryXJXMResult addObject:xjxmParams];
            }
            NSLog(@" xjxmParams %@",[aryXJXMResult JSONString] );

            [request addPostValue:[aryXJXMResult JSONString] forKey:@"xjxmString"];
        }
        else
            [request addPostValue:@"[]" forKey:@"xjxmString"];
        
        NSArray *aryWxfw = [dicData objectForKey:@"wxfwString"];
        if([aryWxfw isKindOfClass:[NSArray class]]&& [aryWxfw count] > 0){
            
            //来组合数据，新建项目放在一个数组里面
            NSMutableArray *aryWXFWResult = [NSMutableArray arrayWithCapacity:3];
            for(NSArray *aryChild in aryWxfw){
                NSMutableDictionary *wxfwParams = [NSMutableDictionary dictionaryWithCapacity:5];
                NSString *wxfwBh =  [GUIDGenerator generateGUID];
                [wxfwParams setValue:wxfwBh forKey:@"BH"];
                [wxfwParams setValue:self.basebh forKey:@"XCJCBH"];
                for(NSDictionary *dicItem in aryChild){
                    [wxfwParams setObject:[dicItem objectForKey:@"value"] forKey:[dicItem objectForKey:@"name"]];
                    
                }
                [aryWXFWResult addObject:wxfwParams];
            }
            
            NSLog(@"wxfwParams %@",[aryWXFWResult JSONString] );
            [request addPostValue:[aryWXFWResult JSONString] forKey:@"wxfwString"];
        }else
            [request addPostValue:@"[]" forKey:@"wxfwString"];
        
        NSLog(@" jsonStrParams %@",[jsonStrParams JSONString] );
        [request addPostValue:[jsonStrParams JSONString] forKey:@"jsonString"];
        
        
        
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
    NSRange result = [resultJSON rangeOfString:@"success"];
    
    if ( result.location!= NSNotFound) 
    {
        
        
        NSDictionary *baseTableJson = [self createBaseTableFromWryData:nil];
        
        [self commitBaseRecordData:baseTableJson];
        
        //删除未提交笔录中暂存的数据
        RecordsHelper *helper = [[RecordsHelper alloc] init];
        [helper deleteRecordByBH:self.basebh andTableName:self.tableName];
        
      
        
        
        
        
    }
    else{
        
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"错误" message:@"笔录提交失败！"];
        
        [alert setCancelButtonTitle:@"确定" block:^{
            self.recordStatus = Record_Commited_Success;
        }];
        
        [alert show];
        
        
        
    }
    
}

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    
    
    return dicParams;
}


@end
