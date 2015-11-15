//
//  SendTaskViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-24.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "SendTaskViewController.h"
#import "ServiceUrlString.h"
#import "UISearchSitesController.h"
#import "PopupDateViewController.h"
#import "PersonChooseVC.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
#import "TaskManagerViewController.h"
#import "PDJsonkit.h"
#import "GUIDGenerator.h"
#import "SystemConfigContext.h"
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>

#define QUERY_YDZF_WRY_DATA 1
#define ASSIGN_TASK_ACTION  2
#define SEND_TASK_SHORTMSG  3

@interface SendTaskViewController ()<SelectSitesDelegate,PopupDateDelegate,PersonChooseResult,ZXingDelegate>
@property(nonatomic,strong)NSString *taskType;
@property(nonatomic,strong)NSString *slrID;

@property(nonatomic,strong)NSString *wrybh;
@property(nonatomic,strong)UIPopoverController *popController;
@property(nonatomic,strong)NSArray *arySLR;//受理人
@end

@implementation SendTaskViewController
@synthesize taskType,wrybh,slrID,popController,arySLR,JCRBM;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.taskType = @"43000000003";
        self.wrybh = @"";
    }
    return self;
}

-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOutside{
    
    NSLog(@"values--%@",values);
        wrymcField.text = [values objectForKey:@"WRYMC"];
        if (bOutside) {
             
            self.wrybh = @"";
        }
        else{
            self.wrybh = [values objectForKey:@"WRYBH"];
            dwdzField.text = [values objectForKey:@"DWDZ"];
            frdbdhField.text = [values objectForKey:@"LXDH"];
            frdbField.text = [values objectForKey:@"FDDBR"];
        }
    if (values == nil) {
        wrymcField.delegate = nil;
        [wrymcField removeTarget:self action:@selector(touchFromWrymcField:) forControlEvents:UIControlEventTouchDown];
    }
}

-(void)assignTask:(id)sender
{
    NSString *tipInfo = nil;
    if([wrymcField.text length] <= 0)
        tipInfo = @"请选择企业";
    else if([dwdzField.text length] <= 0)
        tipInfo = @"请输入企业地址";
    else if([slrField.text length] <= 0)
        tipInfo = @"请选择受理人";
    else if([rwqxField.text length] <= 0)
        tipInfo = @"请选择任务期限";
    if (tipInfo) {
        [self showAlertMessage:tipInfo];
        return;
    }
    NSLog(@"wrymcfield.text===%@\ndwdzfield.text===%@\nslrfield===%@\nrwqxfiel===%@",wrymcField.text,dwdzField.text,slrField.text,rwqxField.text);
    if(sendShortMsgSwitch.on){
         NSArray *aryShouji = [phoneNumsField.text componentsSeparatedByString:@","];
        for(NSString *phone in aryShouji)
        {
            if ([self verifyPhoneNumber:phone] == NO) {
                 
                 [self showAlertMessage:@"手机号码无效,请检查将要发送短信的手机号码。"];
                return;
            }
        }
        
    }
    NSMutableDictionary *infoParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [infoParams setObject:taskType forKey:@"TASK_TYPE"];
    [infoParams setObject:wrymcField.text forKey:@"WRYMC"];
    [infoParams setObject:dwdzField.text forKey:@"DWDZ"];
    [infoParams setObject:slrField.text forKey:@"SLR"];
    [infoParams setObject:self.JCRBM forKey:@"JCRBM"];
    
     [infoParams setObject:rwqxField.text forKey:@"RWQX"];
    if([frdbField.text length]>0)
        [infoParams setObject:frdbField.text forKey:@"FRDB"];
    if([frdbdhField.text length]>0)
        [infoParams setObject:frdbdhField.text forKey:@"FRDBLXDH"];
    
      //受理人用逗号分隔
    [infoParams setObject:slrID forKey:@"SLRID"];
    NSLog(@"slrID=%@",slrID);
    [infoParams setObject:wrybh forKey:@"WRYBH"];
    

     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"ASSIGN_TASK_ACTION" forKey:@"service"];
    [params setObject:[infoParams JSONString] forKey:@"PARAM"];

    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"renwuzhipai=%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在提交任务..." tagID:ASSIGN_TASK_ACTION];
    
    //发送短信
    if(sendShortMsgSwitch.on){
        NSArray *aryShouji = [phoneNumsField.text componentsSeparatedByString:@","];
        if([aryShouji count]<=0)return;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *sendTime = [dateFormatter stringFromDate:[NSDate date]];
        
        SystemConfigContext *context = [SystemConfigContext sharedInstance];
        NSDictionary *userInfo = [context getUserInfo];
     
        NSString *content = [NSString stringWithFormat:@"工作任务：请前往%@（地址:%@）执法监察。任务期限：(%@)之前；受理人：%@；发送人：%@。",wrymcField.text,dwdzField.text,rwqxField.text, slrField.text,[userInfo objectForKey:@"uname"]];
        
        NSMutableDictionary *msgParams = [NSMutableDictionary dictionaryWithCapacity:15];
        
       
        [msgParams setObject:content forKey:@"CONTENT"];
        [msgParams setObject:sendTime forKey:@"SENDTIME"];
        [msgParams setObject:@"PBDX" forKey:@"MKBS"];

        [msgParams setObject: [context getDeviceID] forKey:@"SBID"];
        [msgParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
        
        [msgParams setObject:[userInfo objectForKey:@"depart"] forKey:@"JGFZ"];
        [msgParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CZRY"];
        [msgParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
        [msgParams setObject:sendTime forKey:@"CJSJ"];
        
        NSMutableArray *aryJson = [NSMutableArray arrayWithCapacity:10];
        
        for(NSString *phone in aryShouji)
        {
            NSMutableDictionary *dicItem = [NSMutableDictionary dictionaryWithDictionary:msgParams];
            [dicItem setObject:[GUIDGenerator generateGUID] forKey:@"XH"];
            [dicItem setObject:phone forKey:@"ADDR"];
            [dicItem setObject:[GUIDGenerator generateGUID] forKey:@"SIGN"];
            [aryJson addObject:dicItem];
           
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"SEND_TASK_SHORTMSG" forKey:@"service"];
        [params setObject:[aryJson JSONString] forKey:@"jsonString"];
        
        
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        //   NSMutableString *str = [NSString stringWithFormat:@"%@&PARAM=%@",strUrl,jsonStr];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self  tagID:SEND_TASK_SHORTMSG];
    }
    
    
}

-(IBAction) switchCtrlChanged:(id)sender{
    if (sendShortMsgSwitch.on) {
        phoneNumsField.hidden = NO;
    }else{
        phoneNumsField.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务指派";
    
    [saveButton addTarget:self action:@selector(assignTask:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"查看已指派任务" style:UIBarButtonItemStyleDone target:self action:@selector(showHistoryList:)];
    self.navigationItem.rightBarButtonItem = commitButton;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}

-(IBAction)touchFromDate:(id)sender
{
	UIControl *btn =(UIControl*)sender;
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	dateController.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
    [popController dismissPopoverAnimated:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    rwqxField.text = dateString;
}

-(IBAction)touchFromWrymcField:(id)sender
{
    UISearchSitesController *formViewController = [[UISearchSitesController alloc] initWithNibName:@"UISearchSitesController" bundle:nil];
	[formViewController setDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
	[self presentModalViewController:nav animated:YES];
	nav.view.superview.frame = CGRectMake(30, 100, 700, 700);
}

- (void)showHistoryList:(id)sender
{
    TaskManagerViewController *tm = [[TaskManagerViewController alloc] initWithNibName:@"TaskManagerViewController" bundle:nil];
    [self.navigationController pushViewController:tm animated:YES];
}

-(void)personChoosed:(NSArray*)aryChoosed
{
    
    NSLog(@"bbbbbbbbb8900");
    self.arySLR = aryChoosed;
    [popController dismissPopoverAnimated:YES];
    NSMutableString *strSLRName = [NSMutableString stringWithCapacity:20];
    NSMutableString *strSLRID = [NSMutableString stringWithCapacity:20];
    NSMutableString *strPhones = [NSMutableString stringWithCapacity:20];
    for(NSDictionary *dicPerson in arySLR)
    {
        if([strSLRName length] == 0)
        {
            [strSLRName appendString:[dicPerson objectForKey:@"YHMC"]];
            [strSLRID appendString:[dicPerson objectForKey:@"YHID"]];
            [strPhones appendString:[dicPerson objectForKey:@"YHSJ"]];
        }
        else
        {
            [strSLRName appendFormat:@",%@",[dicPerson objectForKey:@"YHMC"]];
            [strSLRID appendFormat:@",%@",[dicPerson objectForKey:@"YHID"]];
            [strPhones appendFormat:@",%@",[dicPerson objectForKey:@"YHSJ"]];
        }
    }
    self.slrID = strSLRID;
    phoneNumsField.text  = strPhones;
    slrField.text = strSLRName;
}

- (void)getBMMC:(NSString *)bmmcStr{
    
    self.JCRBM = bmmcStr;
    NSLog(@"self.JCRBM=%@",self.JCRBM);
}

-(IBAction)choosePersonField:(id)sender
{
    UIControl *btn =(UIControl*)sender;
    PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
    controller.delegate = self;
    controller.multiUsers = YES;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)processError:(NSError *)error
{
    
}
 
-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if(tag == ASSIGN_TASK_ACTION){
        NSRange result = [resultJSON rangeOfString:@"success"];
        if(result.location!= NSNotFound)
        {
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                        message:@"指派任务成功！还需要指派其它任务吗？"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"指派其它任务" action:^{
                wrymcField.text = @"";
                dwdzField.text = @"";
                frdbField.text = @"";
                frdbdhField.text = @"";
                slrField.text = @"";
                rwqxField.text = @"";
                bzField.text = @"";
                phoneNumsField.text = @"";
                self.wrybh = @"";
                self.arySLR = nil;
                self.slrID = @"";
                
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"不指派" action:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }], nil] show];
            return;
        }
        else
        {
            NSString *msg = @"发送任务失败！";
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"错误"
                                  message:msg  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [[[alert subviews] objectAtIndex:2] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
            [alert show];
            return;
        }
    }
    else  if(tag == QUERY_YDZF_WRY_DATA){
        NSDictionary *dicResult = [resultJSON objectFromJSONString];
        if([dicResult isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dicTotal = [dicResult objectForKey:@"totalCount"];
            NSInteger totalCount = 0;
            if(dicTotal)
                totalCount = [[dicTotal objectForKey:@"ZS"] integerValue];
            if(totalCount > 0){
                NSArray *ary = [dicResult objectForKey:@"data"];
                if([ary count] > 0){
                    NSDictionary *wryInfo = [ary objectAtIndex:0];
                    [self returnSites:wryInfo outsideComp:NO];
                    return;
                }
                
            }
        }
        
        NSString *msg = @"查询该企业数据失败";
        [self showAlertMessage:msg];
        return;
        
        
    }
    else{
        NSLog(@"发送短信返回数据:%@",resultJSON);
    }
    
}

- (void)viewDidUnload {
    saveButton = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

#define MOBILE  @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
#define CM      @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
#define CU      @"^1(3[0-2]|5[256]|8[56])\\d{8}$"
#define CT      @"^1((33|53|8[09])[0-9]|349)\\d{7}$"

- (BOOL)verifyPhoneNumber:(NSString *)mobileNum{
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    //        NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//二维码扫描
-(IBAction) scanQRCode:(id)sender{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widController.readers = readers;
    [self presentViewController:widController animated:YES completion:^{}];
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_YDZF_WRY_DATA" forKey:@"service"];
    [params setObject:result forKey:@"wrybh"];
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    [params setObject:[userInfo objectForKey:@"sjqx"] forKey:@"SJQX"];
    [params setObject:@"1" forKey:@"SFCKXS"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
 
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_YDZF_WRY_DATA] ;
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{[self outPutResult:result];}];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"cancel!");}];
}

@end
