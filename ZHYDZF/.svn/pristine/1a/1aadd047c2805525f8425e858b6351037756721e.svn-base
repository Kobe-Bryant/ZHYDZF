    //
//  QueryWriteController.m
//  HangZhouOA
//
//  Created by chen on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryWriteController.h"
#import <QuartzCore/QuartzCore.h>
#import "SharedInformations.h"
#import "LoginViewController.h"
#import "GUIDGenerator.h"
#import "SystemConfigContext.h"
#import "WendaDetailsViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "RecordsHelper.h"
#import "PersonChooseVC.h"
#import "AHAlertView.h"

#define  T_YDZF_DCXWBL @"T_YDZF_DCXWBL"

@interface QueryWriteController()<PersonChooseResult>

@end

@implementation QueryWriteController

@synthesize wordsSelectViewController,wordsPopoverController,AY;

@synthesize DCXWDD,GZDW,NL,JTZZ,YB,DH,CYR,BXWRMC,SFZHM,XWKSSJ,XWJSSJ,XB,ZW,YBAGX,JLR,ZFRY,SFQR,ZFZH,SQHB,XWR;
@synthesize popController,dateController;
@synthesize quesValueAry,ansValueAry;
@synthesize CYR_ZJH,LRR_ZJH;
@synthesize surePreson;
@synthesize valuesAry,keysAry,jbxx,isCKXQ;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.tableName = T_YDZF_DCXWBL;
	
    return self;
}
-(IBAction)backgroundTap:(id)sender
{
    [SQHB resignFirstResponder];
    [SFQR resignFirstResponder];
    [BXWRMC resignFirstResponder];
    [NL resignFirstResponder];
    [ZW resignFirstResponder];
    [SFZHM resignFirstResponder];
    [JTZZ resignFirstResponder];
    [YB resignFirstResponder];
    [DH resignFirstResponder];
    [YBAGX resignFirstResponder];
    [CYR resignFirstResponder];
    
}
-(IBAction)beginEditing:(id)sender{
    
	UIControl *ctrl = (UIControl*)sender;
	CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;	
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[wordsSelectViewController.tableView reloadData];
 
    
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionUp
											   animated:YES];
     
}
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
	
	YBAGX.text = words;
	if (wordsPopoverController != nil) {
		[wordsPopoverController dismissPopoverAnimated:YES];
	}
}
-(IBAction)NewQuestion:(id)sender
{
    WendaDetailsViewController *controller = [[WendaDetailsViewController alloc] initWithNibName:@"WendaDetailsViewController" bundle:nil];	

    controller.QYMC = self.wrymc;
    controller.wdDelegate = self;
    if([quesValueAry count] > 0){
        controller.quesValueAry = quesValueAry;
        controller.ansValueAry = ansValueAry; 
    }
    else{
        controller.quesValueAry = [NSMutableArray arrayWithCapacity:15];
        controller.ansValueAry = [NSMutableArray arrayWithCapacity:15];
    }
    
	[self.navigationController pushViewController:controller animated:YES];

}
-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDateAndTime];
	self.dateController = tmpdate;
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{ 
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (currentTag) {
			case 102:				
				XWKSSJ.text = dateString;

				break;
			case 2:
				XWJSSJ.text = dateString;

				break;
			default:
				break;
		}
	}
    
    if ([XWKSSJ.text compare:XWJSSJ.text] == NSOrderedDescending)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"结束时间不能早于开始时间"  
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        XWJSSJ.text = @"";
        
    }

}
-(void)returnquesAry:(NSMutableArray*)values returnansAry:(NSMutableArray*)values1{
    
	self.quesValueAry = values;
    self.ansValueAry = values1;
}
-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
	if (values == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.wrymc = GZDW.text = [values objectForKey:@"WRYMC"];
            self.dwbh = @"";
            self.DCXWDD.text = @"";
        }
        else
        {
            NSLog(@"[values allKeys]%@",[values allKeys]);
            self.wrymc =  GZDW.text = [values objectForKey:@"WRYMC"];
            self.dwbh = [values objectForKey:@"WRYBH"];
            self.DCXWDD.text = [values objectForKey:@"DWDZ"];
            self.BXWRMC.text = [values objectForKey:@"BXWR"];
            self.DH.text = [values objectForKey:@"HBRLXDH"];
            self.YB.text = [values objectForKey:@"YB"];
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.dicWryInfo = values;
        }
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
       
	}
}
-(void)commitBilu:(id)sender
{
    
    if (_isHaveSelect) {
        
        [self.view endEditing: YES];
        return;
    }
    NSString *message = nil;
    if([XWKSSJ.text isEqualToString:@""])
        message = @"开始时间不能为空";
    else if([XWJSSJ.text isEqualToString:@""])
        message = @"结束时间不能为空";
    else if([quesValueAry count]==0)
        message = @"问答不能为空";
    
    if (message != nil) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:message  
                              delegate:nil
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
   
    NSDictionary *dicData = [self getValueData];
	[self commitRecordDatas:dicData];
    
    return;

}
-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    [dicParams setObject:[value objectForKey:@"KSSJ"] forKey:@"KSSJ"];
    [dicParams setObject:[value objectForKey:@"XWR"]    forKey:@"JCR"];

    return dicParams;
}
-(void)commitRecordDatas:(NSDictionary *)value{
    

    NSMutableArray *aryWD = [NSMutableArray arrayWithCapacity:3];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
	int sizeQA = [quesValueAry count];
    for (int i=0; i< sizeQA; i++)
    {
         NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:10];
        [dicParams setObject:[userInfo objectForKey:@"uname"] forKey:@"CJR"];
        [dicParams setObject:dateString forKey:@"CJSJ"];
        [dicParams setObject:[userInfo objectForKey:@"uname"]  forKey:@"XGR"];
        [dicParams setObject:dateString forKey:@"XGSJ"];
        [dicParams setObject:[userInfo objectForKey:@"orgid"] forKey:@"ORGID"];
        
        
        [dicParams setObject:[GUIDGenerator generateGUID] forKey:@"BH"];
        [dicParams setObject:self.basebh forKey:@"BLBH"];
        [dicParams setObject:@"T_YDZF_DCXWBL" forKey:@"BLLX"];
        [dicParams setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"PXH"];
        [dicParams setObject:[quesValueAry objectAtIndex:i] forKey:@"WT"];
        [dicParams setObject:[ansValueAry objectAtIndex:i] forKey:@"DA"];
        
        [aryWD addObject:dicParams];
    }
    
    NSString *jsonStr = [value JSONString];
    
    NSString *wdStr = [aryWD JSONString];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"COMIT_BL_DCXWBL" forKey:@"service"];
    [params setObject:jsonStr forKey:@"jsonString"];
    [params setObject:wdStr forKey:@"wdString"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在提交笔录..." tagID:COMIT_BL_DCXWBL];

}
-(void)saveBilu:(id)sender
{
    if (_isHaveSelect) {
        
        [self.view endEditing: YES];
        return;
    }
    
    NSString *message = nil;
    if([XWKSSJ.text isEqualToString:@""])
        message = @"开始时间不能为空";
    else if([XWJSSJ.text isEqualToString:@""])
        message = @"结束时间不能为空";
    else if([quesValueAry count]==0)
        message = @"问答不能为空";
    
    if (message != nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return ;
    }
    [super saveBilu:sender];
    NSDictionary *dicData = [self getValueData];
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithDictionary:dicData];
    [dicValue setValue:self.xczfbh forKey:@"XCZFBH"];
    
    RecordsHelper *helper = [[RecordsHelper alloc] init];
    BOOL res = [helper saveWDRecordWT:quesValueAry andDA:ansValueAry BLBH:self.basebh];
    if(res == NO){
        NSLog(@"保存询问笔录失败");
        return;
    }
    [self saveLocalRecord:dicValue];
    
}
- (void)loadData:(NSDictionary *)infoDic{

    UITextField *tmpField;
    for (int i = 0; i < [keysAry count]; i++) {
        tmpField = [valuesAry objectAtIndex:i];
        
        tmpField.text = [infoDic objectForKey:[keysAry objectAtIndex:i]];
        NSLog(@"tmpField.text=%@",tmpField.text);
    }
    if([[infoDic objectForKey:@"XB"] isEqualToString:@"男"])
        XB.selectedSegmentIndex = 0;
    else
        XB.selectedSegmentIndex = 1;
}
//根据值来显示值
-(void)displayRecordDatas:(NSDictionary*)object{

    NSDictionary* values =[self modifyDicValues:object];
    [self loadData:values];
  //  NSString *zfbh = [values objectForKey:@"XCZFBH"];
    NSString *blbh = [values objectForKey:@"BH"];
    if([blbh length] > 0){
        
        if (self.displayFromLocal) {
            NSLog(@"here");
            RecordsHelper *helper = [[RecordsHelper alloc] init];
            NSArray *ary = [helper queryWDRecordByBH:blbh];
            
            NSMutableArray *aryWT = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *aryDA = [NSMutableArray arrayWithCapacity:10];
            for(NSDictionary *item in ary){
                [aryWT addObject:[item objectForKey:@"WT"]];
                [aryDA addObject:[item objectForKey:@"DA"]];
            }
            self.ansValueAry = aryDA;
            self.quesValueAry = aryWT;
            
        }else{
            
            NSLog(@"there");
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
            [params setObject:@"QUERY_DCXWBL_WD_HISTORY" forKey:@"service"];
            [params setObject:blbh forKey:@"BH"];
            
            
            NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
            self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_DCXWBL_WD_HISTORY] ;
        }
        
    }
}
-(NSDictionary*)getValueData{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
    if(self.dicWryInfo)
        [dicParams setDictionary:self.dicWryInfo];

    UITextField *tmpField;
    for (int i = 0; i < [keysAry count]; i++) {
        tmpField = [valuesAry objectAtIndex:i];
        [dicParams setObject:tmpField.text forKey: [keysAry objectAtIndex:i]];
    }

    NSLog(@"here");

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
//    [dicParams setObject:dateString forKey:@"JSSJ"];

    [dicParams setObject:self.xczfbh forKey:@"XCZFBH"];

    [dicParams setObject:self.basebh forKey:@"BH"];
    [dicParams setObject:self.dwbh forKey:@"WRYBH"];
    [dicParams setObject:self.wrymc forKey:@"DWMC"];
    if(XB.selectedSegmentIndex == 0)
        [dicParams setObject:@"男" forKey:@"XB"];
    else
        [dicParams setObject:@"女" forKey:@"XB"];
    
    return dicParams;
}

-(void)requestHistoryData{
    [super requestHistoryData];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_DCXWBL_HISTORY" forKey:@"service"];
    [params setObject:self.basebh forKey:@"BH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_DCXWBL_HISTORY] ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ppppppppppppp");
    self.rDic = [[NSDictionary alloc]init];
    self.valuesAry = [NSArray arrayWithObjects:AY,DCXWDD,GZDW,NL,JTZZ,YB,DH,CYR,BXWRMC,SFZHM,XWKSSJ,XWJSSJ,ZW,YBAGX,XWR,JLR,ZFRY,SFQR,ZFZH,SQHB,DLRSSBM,nil];
    self.keysAry = [NSArray arrayWithObjects:@"AY",@"DD",@"DW",@"NL",@"BXWRDZ",@"YZBM",@"LXDH",@"CYR",@"BXWR",@"SFZH",@"KSSJ",@"JSSJ",@"ZY",@"YBAGX",@"XWR",@"JLR",@"ZFRY",@"YYLY",@"ZFZH",@"HBLY",@"HBBM",nil];
    self.title = @"询问记录";
    
    NSLog(@"self.rDic----%@",self.rDic);
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *sjqx = [userInfo objectForKey:@"sjqx"];
    
    UsersHelper *helper =[[UsersHelper alloc] init];
    NSString *dwmc = [helper queryHBJMCBySJQX:sjqx];
    DLRSSBM.text = dwmc;
    NSLog(@"cc----%@",dwmc);
    
    JLR.text =  [userInfo objectForKey:@"uname"];
    NSLog(@"vv----%@",[userInfo objectForKey:@"uname"]);

    
    SFQR.text = @"已确认";
    SQHB.text = @"听清楚了，不申请回避。";
   
    CommenWordsViewController *tmpController2 = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController2.contentSizeForViewInPopover = CGSizeMake(180, 132);
	tmpController2.delegate = self;
	tmpController2.wordsAry = [NSArray arrayWithObjects:@"法人代表",@"受委托人",
                               @"旁证",nil];
    
    UIPopoverController *tmppopover2 = [[UIPopoverController alloc] initWithContentViewController:tmpController2];
	self.wordsSelectViewController = tmpController2;
    self.wordsPopoverController = tmppopover2;
    
	AY.text = @"";
    
    NSDate *time = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *dateString = [dateFormatter stringFromDate:time];
	
	XWKSSJ.text = dateString;

    self.CYR_ZJH = @"";
    self.LRR_ZJH = @"";
    //如果没有污染源编号，手动添加的污染源
    if (self.dwbh == nil ||[self.dwbh isEqualToString:@""])
    {
        if(self.isHisRecord)
        {
            //详情
            //[self displayRecordDatas:self.is];
        }
        else
        {
            [self disPlayTextViewText];
        }
    }
}
-(void)disPlayTextViewText{
    
    self.JLR.text = [NSString stringWithFormat:@"%@", [[self.jbxx objectAtIndex:6] objectForKey:@"CONTENT"]];
    self.DCXWDD.text = [[self.jbxx objectAtIndex:1] objectForKey:@"CONTENT"];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (self.isHisRecord) {
        NSArray *ary= [self.view subviews];
        
        for(UIView *childView in ary){
            if ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UISegmentedControl class]]|| [childView isKindOfClass:[UITextView class]] || [childView isKindOfClass:[UISwitch class]]) {
                UIControl *ctrl = (UIControl*)childView;
                ctrl.userInteractionEnabled = NO;
            }
        }
    }
    
	if (wordsPopoverController != nil) {
		[wordsPopoverController dismissPopoverAnimated:YES];
	}
    
}
	
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark textfieldDelegate delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 119 || textField.tag == 120 || textField.tag == 106|| textField.tag == 108|| textField.tag == 111|| textField.tag == 112) {
        
        if (textField.tag < 119) {
            
            _isHaveSelect = YES;
        }
        return YES;
    }
    return NO;
}
// 用户输入时向上滚动视图，避免键盘遮挡输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat arrange = 0.0;
    if (textField.tag == 119) {
        arrange = - 20;
    }
    if (textField.tag == 120) {
        arrange = - 150;
    }
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,arrange,width,height);//上移，按实际情况设置
    self.view.frame=rect;
    [UIView commitAnimations];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 120){
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width=self.view.frame.size.width;
        float height=self.view.frame.size.height;
        CGRect rect=CGRectMake(0.0f,0.0f,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
    
    _isHaveSelect = NO;
    _textFTag = textField.tag;
    NSString *testStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (testStr.length == 0) {
        return;
    }
    
    [self outResult:testStr withTag:_textFTag];

}
//格式判断方法

- (void)outResult:(NSString *)content withTag:(int)tag{
    
    NSString *msg = @"";
    switch (tag) {
        case 106:{
            
            if (![self formatTest:content withFormatType:positiveNumber]) {
                
                msg = @"请输入合法年龄";
            }
        }
            break;
        case 108:{
            
            if (![self formatTest:content withFormatType:idNumber]) {
                
                msg = @"请输入合法身份证号";
            }
        }
            break;
        case 111:{
            
            if (![self formatTest:content withFormatType:postalNumber]) {
                
                msg = @"请输入合法邮编";
            }
        }
            break;
        case 112:{
            
            if (![self formatTest:content withFormatType:phoneNumber]) {
                
                msg = @"请输入合法电话";
            }
        }
            break;
        default:
            break;
    }
    
    if (msg.length != 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        alertView.tag = 2000;
        [alertView show];
        UITextField *txtF = (UITextField *)[self.view viewWithTag:_textFTag];
        txtF.text = @"";
        return;
    }
}
- (BOOL)formatTest:(NSString *)testStr withFormatType:(formatSelect)type{
    
    NSPredicate *regextestmobile;
    switch (type) {
        case phoneNumber:{
            NSString *MO= @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";//联通
            NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";//移动
            NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";//电信
            NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";//固话，小灵通
            
            NSArray *arr = [NSArray arrayWithObjects:MO,CM,CU,CT, nil];
            
            for (NSString *MOBILE in arr) {
                
                regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
                
                if ([regextestmobile evaluateWithObject:testStr]){
                    
                    return [regextestmobile evaluateWithObject:testStr];
                    
                }
            }
        }
            break;
        case idNumber:{
            
            NSString *ID = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
            regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ID];
        }
            break;
        case postalNumber:{
            
            NSString *POSTAL = @"^\\d{6}$";
            regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", POSTAL];
        }
            break;
        case positiveNumber:{
            
            NSString *positive = @"([0-9])|([1-9][0-9])|100";
            regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positive];
        }
            break;
        default:
            break;
    }
    return [regextestmobile evaluateWithObject:testStr];
}


-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    
    if(tag != COMIT_BL_DCXWBL && tag != QUERY_DCXWBL_HISTORY && tag != QUERY_DCXWBL_WD_HISTORY)
        return [super processWebData:webData andTag:tag];
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (tag == COMIT_BL_DCXWBL) {
        
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
    else if (tag == QUERY_DCXWBL_HISTORY) {
      
        NSDictionary *dicInfo = [resultJSON objectFromJSONString];
        
        if(dicInfo){
            NSArray *ary = [dicInfo objectForKey:@"data"];
            if ([ary count] > 0) {
                NSDictionary *dicRecordData = [ary objectAtIndex:0];
                [self displayRecordDatas:dicRecordData];
            }
        }
    }
    else if(tag == QUERY_DCXWBL_WD_HISTORY){
 
        NSDictionary *dicInfo = [resultJSON objectFromJSONString];
        if(dicInfo){
            NSArray *ary = [dicInfo objectForKey:@"data"];
            if ([ary count] > 0) {
                self.quesValueAry = [NSMutableArray arrayWithCapacity:10];
                self.ansValueAry = [NSMutableArray arrayWithCapacity:10];
                for(NSDictionary *dicItem in ary){
                    [quesValueAry addObject:[dicItem objectForKey:@"WT"]];
                     [ansValueAry addObject:[dicItem objectForKey:@"DA"]];
                }
            }
        }
    }
}
-(void)processError:(NSError *)error{
    
}
-(void)personChoosed:(NSArray*)aryChoosed{
    
    [popController dismissPopoverAnimated:YES];
    NSMutableString *strSLRName = [NSMutableString stringWithCapacity:20];
    NSMutableString *strSlrZFZH = [NSMutableString stringWithCapacity:20];
    
    for(NSDictionary *dicPerson in aryChoosed){
        NSString * zfzh = [dicPerson objectForKey:@"ZFZH"];
        
        if([strSLRName length] == 0){
            
            [strSLRName appendString:[dicPerson objectForKey:@"YHMC"]];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strSlrZFZH appendString:zfzh];
            
        }else{
            [strSLRName appendFormat:@",%@",[dicPerson objectForKey:@"YHMC"]];
            if([zfzh length] > 0 && ![zfzh isEqualToString:@"null"])
                [strSlrZFZH appendFormat:@",%@",zfzh];
            
        }
        
    }

    if (currentTag == XWR.tag) {
        XWR.text = strSLRName;
    }
    else if(currentTag == ZFRY.tag){
        ZFRY.text = strSLRName;
         ZFZH.text = strSlrZFZH;//执法证号
    }
}

-(IBAction)choosePerson:(id)sender{
   UIControl *btn =(UIControl*)sender;
    
    PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
    
	controller.delegate = self;
    controller.multiUsers = YES;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    currentTag = btn.tag;
}

@end
