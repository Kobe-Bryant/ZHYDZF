    //
//  SiteInforcementConroller.m
//  EPad
//
//  Created by chen on 11-4-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SiteInforcementConroller.h"
#import "LoginViewController.h"
#import "UISearchSitesController.h"
#import "GUIDGenerator.h"
#import "SharedInformations.h"
#import <QuartzCore/QuartzCore.h>
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "UISelectPersonVC.h"
#import "DrawKYTViewController.h"
#import "AHAlertView.h"

typedef enum{
    
    phoneNumber = 0,
    idNumber,
    postalNumber,
    positiveNumber
}formatSelect;
@implementation SiteInforcementConroller

@synthesize XCFZR,NL,SFZHM,GZDW,ZW,YBAGX,JTZZ,DH,QTJZR,ZFZH,QRSF,SQHB,XCQK,ZFRY,KYKSSJ,KYJSSJ,KYDD,KCDWFDMC,FDDBR,FDDBRDH,JCRBM;
@synthesize popController;
@synthesize JCR,JLR,HBBM,jbxx,isCKXQ;

#define T_YDZF_XCKCBL @"T_YDZF_XCKCBL"
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    self.tableName = T_YDZF_XCKCBL;
    
    return self;
}
-(IBAction)beginEditing:(id)sender{
	UIControl *ctrl = (UIControl*)sender;
	CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;	
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	
    CommenWordsViewController *tmpController2 = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController2.contentSizeForViewInPopover = CGSizeMake(320, 132);
	tmpController2.delegate = self;
	tmpController2.wordsAry = [NSArray arrayWithObjects:@"法人代表",@"受委托人",
                               @"旁证",nil];
    
    UIPopoverController *tmppopover2 = [[UIPopoverController alloc] initWithContentViewController:tmpController2];

    self.popController = tmppopover2;
	[self.popController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionUp
											   animated:YES];
}
-(IBAction)touchFromDate:(id)sender{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	UIControl *btn =(UIControl*)sender;
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDateAndTime];

	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;

	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [popController dismissPopoverAnimated:YES];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (currentTag) {
			case 102:
				KYKSSJ.text = dateString;
                //     //NSLog(@"11%@",XWKSSJ);
                //  self.TZSJDateValue = date;
				break;
			case 103:
				KYJSSJ.text = dateString;
                //  self.JSCLSJDateValue = date;
				
				break;
			default:
				break;
		}
    
    
    NSLog(@"start:%@ end:%@",KYKSSJ.text,KYJSSJ.text);
    if ([KYKSSJ.text compare:KYJSSJ.text] == NSOrderedDescending || [KYKSSJ.text compare:KYJSSJ.text] == NSOrderedSame)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"结束时间不能早于开始时间"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        KYJSSJ.text= @"";
        
    }
    
}
-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
	
	YBAGX.text = words;
	if (popController != nil) {
		[popController dismissPopoverAnimated:YES];
	}
}
-(NSDictionary*)getValueData{
    //缺少天气TQ、KCDWFDMC 、DWDZ、YB、FDDBRLXDH
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:25];
    if(self.dicWryInfo)
        [dicParams setDictionary:self.dicWryInfo];
    [dicParams setObject:self.wrymc forKey:@"WRYMC"];
    [dicParams setObject:KCDWFDMC.text forKey:@"KCDWFDMC"];
    [dicParams setObject:KYKSSJ.text forKey:@"KCKSSJ"];
    [dicParams setObject:KYJSSJ.text forKey:@"KCJSSJ"];
    [dicParams setObject:KYDD.text forKey:@"KCDD"];
    
    [dicParams setObject:NL.text forKey:@"NL"];
    [dicParams setObject:JTZZ.text forKey:@"DZ"];
    [dicParams setObject:FDDBR.text forKey:@"FDDBR"];
    
    [dicParams setObject:FDDBRDH.text forKey:@"FDDBRLXDH"];
    
    [dicParams setObject:XCFZR.text forKey:@"XCFZR"];
    [dicParams setObject:SFZHM.text forKey:@"GMSHHM"];
    [dicParams setObject:GZDW.text forKey:@"GZDW"];
    [dicParams setObject:ZW.text forKey:@"ZW"];
    //工作单位及职务
    [dicParams setObject:DH.text forKey:@"XCFZRLXDH"];
    [dicParams setObject:JCR.text forKey:@"JCR"];
    if (self.JCRBM.length != 0) {
        [dicParams setObject:JCRBM forKey:@"JCRBM"];
    }
    
    [dicParams setObject:JLR.text forKey:@"JLR"];
    [dicParams setObject:QTJZR.text forKey:@"QTCJRXX"];
    [dicParams setObject:YBAGX.text forKey:@"YBAGX"];
    if (HBBM.text.length > 0) {
        
        [dicParams setObject:HBBM.text forKey:@"HBBM"];
    }
    
    [dicParams setObject:ZFRY.text forKey:@"ZFRXM"];
    [dicParams setObject:ZFZH.text forKey:@"ZFZH"];
    //疑义理由、申请回避
    [dicParams setObject:QRSF.text forKey:@"YYLY"];
    [dicParams setObject:SQHB.text forKey:@"HBLY"];
    [dicParams setObject:XCQK.text forKey:@"XCQK"];
    
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
    if (self.basebh.length != 0) {
        [dicParams setObject:self.basebh forKey:@"BH"];
    }
    
    [dicParams setObject:self.dwbh forKey:@"WRYBH"];

    return dicParams;
}

-(void)saveBilu:(id)sender
{
    
    if (_isHaveSelect) {
        
        [self.view endEditing: YES];
        return;
    }
    
    NSString *message = nil;
    if([KYKSSJ.text isEqualToString:@""])
        message = @"开始时间不能为空";
    else if([KYJSSJ.text isEqualToString:@""])
        message = @"结束时间不能为空";
    
    
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
    [self saveLocalRecord:dicValue];
}
-(void)commitBilu:(id)sender
{
    NSLog(@"papapapap监察记录");
    if (_isHaveSelect) {
        
        [self.view endEditing: YES];
        return;
    }
    NSString *message = nil;
    if([KYKSSJ.text isEqualToString:@""])
        message = @"开始时间不能为空";
    else if([KYJSSJ.text isEqualToString:@""])
        message = @"结束时间不能为空";
    
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
    
    NSDictionary *dicValue = [self getValueData];
	[self commitRecordDatas:dicValue];
    
}

-(NSMutableDictionary*)createBaseTableFromWryData:(NSDictionary*)value{
    NSMutableDictionary *dicParams = [super createBaseTableFromWryData:value];
    [dicParams setObject:[value objectForKey:@"KCKSSJ"] forKey:@"KSSJ"];
    
    [dicParams setObject:[value objectForKey:@"JCR"]    forKey:@"JCR"];

    return dicParams;
}

//提交数据到对应的笔录表中
-(void)commitRecordDatas:(NSDictionary*)value{
    
    NSLog(@"提交监察记录");
    NSString *jsonStr = [value JSONString];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"COMIT_BL_XCKCBL" forKey:@"service"];
    [params setObject:jsonStr forKey:@"jsonString"];
    
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strUrl=%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在提交笔录..." tagID:COMIT_BL_XCKCBL];
}
-(void)displayRecordDatas:(NSDictionary*)object{
    NSDictionary* valueDatas =[self modifyDicValues:object];
    ZFRY.text = [valueDatas objectForKey:@"ZFRXM"];
    ZFZH.text = [valueDatas objectForKey:@"ZFZH"];
    QRSF.text = [valueDatas objectForKey:@"YYLY"];
    SQHB.text = [valueDatas objectForKey:@"HBLY"];
    XCQK.text = [valueDatas objectForKey:@"XCQK"];
    
    KYKSSJ.text = [valueDatas objectForKey:@"KCKSSJ"];
    KYJSSJ.text = [valueDatas objectForKey:@"KCJSSJ"];
    KYDD.text   = [valueDatas objectForKey:@"KCDD"];

    XCFZR.text = [valueDatas objectForKey:@"XCFZR"];
    NL.text    = [valueDatas objectForKey:@"NL"];
    SFZHM.text = [valueDatas objectForKey:@"GMSHHM"];
    ZW.text    = [valueDatas objectForKey:@"ZW"];

    GZDW.text = [valueDatas objectForKey:@"GZDW"];
    JTZZ.text = [valueDatas objectForKey:@"DZ"];
    DH.text   = [valueDatas objectForKey:@"XCFZRLXDH"];
    YBAGX.text = [valueDatas objectForKey:@"YBAGX"];
    QTJZR.text = [valueDatas objectForKey:@"QTCJRXX"];
    
    KCDWFDMC.text = [valueDatas objectForKey:@"KCDWFDMC"];
    FDDBR.text = [valueDatas objectForKey:@"FDDBR"];
    JCR.text   = [valueDatas objectForKey:@"JCR"];
    JLR.text   = [valueDatas objectForKey:@"JLR"];
    HBBM.text  = [valueDatas objectForKey:@"HBBM"];

}
-(void)returnSites:(NSDictionary*)values outsideComp:(BOOL)bOut{
    
        
	if (values == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
        if (bOut) {
            [btnTitleView setTitle:[values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
             self.wrymc = self.title =  self.GZDW.text = [values objectForKey:@"WRYMC"];
             self.dwbh = @"";
        }
        else
        {
            self.dwbh = [values objectForKey:@"WRYBH"];
            self.wrymc = self.title =  GZDW.text =   [values objectForKey:@"WRYMC"];
            KCDWFDMC.text = self.wrymc;
            KYDD.text = [values objectForKey:@"DWDZ"];
            FDDBR.text =  [values objectForKey:@"FDDBR"];
            XCFZR.text = [values objectForKey:@"XCFZR"];
            DH.text = [values objectForKey:@"XCFZRLXDH"];
           
            [btnTitleView setTitle: [values objectForKey:@"WRYMC"] forState:UIControlStateNormal];
            self.dicWryInfo = values;
            
            NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];

             JLR.text = [userInfo objectForKey:@"uname"];
            
            
        }
        bOutSide = bOut;
        [self  queryXCZFBH];
        [super returnSites:values outsideComp:bOut];
	}
}
-(void)requestHistoryData{
    [super requestHistoryData];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_XCKCBL_HISTORY" forKey:@"service"];
    //[params setObject:@"QUERY_KYT_HISTORY" forKey:@"service"];

    [params setObject:self.basebh forKey:@"BH"];
    NSLog(@"basebh====%@",self.basebh);
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"strurl====%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在查询数据..." tagID:QUERY_XCKCBL_HISTORY] ;
   
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"现场勘验记录";
    
    //bCommited = NO;
    XCQK.layer.borderColor = UIColor.grayColor.CGColor;  //textview边框颜色
    XCQK.layer.borderWidth = 2;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *current = [NSDate date];
    NSString *currentStr = [dateFormatter stringFromDate:current];
    //结束时间比当前时间晚30分钟
     NSString *overStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:30*60]];
    KYKSSJ.text = currentStr;
    KYJSSJ.text = overStr;
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *sjqx = [userInfo objectForKey:@"sjqx"];
    UsersHelper *helper =[[UsersHelper alloc] init];
    NSString *dwmc = [helper queryHBJMCBySJQX:sjqx];
    if(dwmc != nil)
        HBBM.text = dwmc;
    else
        HBBM.text = @"";
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

    self.FDDBR.text = [[self.jbxx objectAtIndex:3] objectForKey:@"CONTENT"];
    self.FDDBRDH.text = [[self.jbxx objectAtIndex:4] objectForKey:@"CONTENT"];
    self.JLR.text = [NSString stringWithFormat:@"%@", [[self.jbxx objectAtIndex:6] objectForKey:@"CONTENT"]];
    self.KYDD.text = [[self.jbxx objectAtIndex:1] objectForKey:@"CONTENT"];
    self.KCDWFDMC.text = [[self.jbxx objectAtIndex:0] objectForKey:@"CONTENT"];
    
    NSLog(@"fddbr===%@\n fddbrdh===%@\n jlr===%@\n kydd===%@\n kcdwfdmc===%@",self.FDDBR.text,self.FDDBRDH.text,self.JLR.text,self.KYDD.text,self.KCDWFDMC.text);
    
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
        self.btnDraw.hidden = YES;
    }
    else{
        [XCFZR resignFirstResponder];
        if (wordsPopoverController != nil) {
            [wordsPopoverController dismissPopoverAnimated:YES];
        }
    }

}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//// 对应的UITextview控件设置delegate就会响应此函数
-(void)textViewDidBeginEditing:(UITextView *)textView{

	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width=self.view.frame.size.width;
	float height=self.view.frame.size.height;
	CGRect rect=CGRectMake(0.0f,-240,width,height);//上移，按实际情况设置
	self.view.frame=rect;
	[UIView commitAnimations];
	return ;
}
-(void)textViewDidEndEditing:(UITextView *)textView{

	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width=self.view.frame.size.width;
	float height=self.view.frame.size.height;
	CGRect rect=CGRectMake(0.0f,0.0f,width,height);
	self.view.frame=rect;
	[UIView commitAnimations];

}
#pragma mark- UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 1022 || textField.tag == 1033 || textField.tag == 109) {
        
        _isHaveSelect = YES;
        return YES;
    }
	return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    _isHaveSelect = NO;
    _textFTag = textField.tag;
    NSString *testStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (testStr.length == 0) {
        return;
    }
    
    [self outResult:testStr withTag:_textFTag];
}
-(void)outResult:(NSString *)content withTag:(int)tag{
    
    NSString *msg = @"";
    switch (tag) {
        case 1022:{
            
            if (![self formatTest:content withFormatType:positiveNumber]) {
                
                msg = @"请输入合法年龄";
            }
        }
            break;
        case 1033:{
            
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
        case 109:{
            
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
-(BOOL)formatTest:(NSString *)testStr withFormatType:(formatSelect)type{
    
    NSPredicate *regextestmobile;
    switch (type) {
        case phoneNumber:{
                        
            NSString *MO= @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";//联通
            NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";//移动
            NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";//电信
            NSString * CT = @"^1((33|53|8[019])[01-9]|349)\\d{7}$";//固话，小灵通
            
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
-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil
}
-(void)viewWillDisappear:(BOOL)animated{
   
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"siteinfor" object:nil];
}
-(void)xczfbhHasGenerated{
    
}
-(void)getBMMC:(NSString *)bmmcStr{

    if (self.JCRBM.length == 0) {
        self.JCRBM = bmmcStr;
    }
}
-(void)personChoosed:(NSArray*)aryChoosed{
    
    
    if([aryChoosed count] < 2){
        NSString *msg = @"检查（勘验）人不能少于2人！";
        [self showAlertMessage:msg];
        return;
    }
    
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

    if(currentTag == 101){//监察人
        JCR.text = strSLRName;
        
    }else if(currentTag == 103){//执法人员
        ZFRY.text = [NSString stringWithFormat:@"%@",strSLRName];
        ZFZH.text = strSlrZFZH;//执法证号
    }

}
-(IBAction)choosePerson:(id)sender{
    
    NSLog(@"zheli");
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
-(void)processError:(NSError *)error{
    
}
//[{"MBBH":"2013082815162662fd52da9c19402b9f2611775a8d5a27","MBMC":"上海市现场检查记录","SIZE":0}]
-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag{
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
-(IBAction)drawKYT:(id)sender{
    
    DrawKYTViewController *controller =[[DrawKYTViewController alloc] initWithNibName:@"DrawKYTViewController" bundle:nil];
    controller.dwbh = self.dwbh;
    controller.dicWryInfo = self.dicWryInfo;
    controller.wrymc = self.wrymc;
    controller.xczfbh = self.xczfbh;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
