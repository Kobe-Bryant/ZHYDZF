//
//  LoginViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "MenuHelper.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginViewController ()
@property(nonatomic,strong)UITextField *usrField;
@property(nonatomic,strong)UITextField *pwdField;
@property(nonatomic,strong)UISwitch *pwdSwitchCtrl;
@property(nonatomic,strong)UIScrollView *changeScrollView;
@property(nonatomic,strong)UIImageView *changeimgView;
@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,strong)UIImageView *logoImgView;
@property(nonatomic,strong)UIImageView *lineView;
@end




@implementation LoginViewController
@synthesize usrField,pwdField,pwdSwitchCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)configSkins{
    NSString* skinColor = [[NSUserDefaults standardUserDefaults] objectForKey:KSkinColor];
    
    if ([skinColor isEqualToString:@"green"] )
    {
        [self.bgImgView setImage:[UIImage imageNamed:@"loginBg_green.jpg"]];
        [self.logoImgView setImage:[UIImage imageNamed:@"login_logo_green"]];
        [self.changeimgView setImage:[UIImage imageNamed:@"btn_pulldown_green.png"]];

    }
    else
    {
        [self.bgImgView setImage:[UIImage imageNamed:@"loginBg.jpg"]];
        [self.logoImgView setImage:[UIImage imageNamed:@"login_logo"]];
        [self.changeimgView setImage:[UIImage imageNamed:@"btn_pulldown.png"]];
        
    }
}

-(void)addUIViews
{
 
    self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
    self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 110, 428, 165)];
    self.changeimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    
    
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.logoImgView];

    [self configSkins];
    self.changeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(320, 620, 120,200)];
    self.changeScrollView.contentSize = CGSizeMake(60, 210);
    self.changeScrollView.showsVerticalScrollIndicator = NO;
    //self.changeScrollView.bounces = NO;
    self.changeScrollView.delegate = self;
    //[self.changeScrollView setBackgroundColor:[UIColor blackColor]];
  //  [self.view addSubview:self.changeScrollView];
    
    [self.changeScrollView addSubview:self.changeimgView];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(60, 0, 3, 0)];
    line.backgroundColor = [UIColor whiteColor];
    self.lineView = line;
    [self.changeScrollView addSubview:line];
    

    self.usrField = [[UITextField alloc]  initWithFrame:CGRectMake(265, 395, 190, 40)];
    usrField.borderStyle = UITextBorderStyleNone;
    usrField.font = [UIFont systemFontOfSize:21];
    usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;//设置首字母不自动大写
    usrField.autocorrectionType = UITextAutocorrectionTypeNo;//设置不自动更正
    [self.view addSubview:usrField];
    self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(265, 455, 190, 40)];
    pwdField.borderStyle = UITextBorderStyleNone;
    pwdField.font = [UIFont systemFontOfSize:21];
    pwdField.secureTextEntry = YES;
    [self.view addSubview:pwdField];
    
    UILabel *savePwd = [[UILabel alloc] initWithFrame:CGRectMake(235, 505, 80, 30)];
    savePwd.backgroundColor = [UIColor clearColor];
    savePwd.textColor = [UIColor lightGrayColor];
    savePwd.text = @"记住密码";
    [self.view addSubview:savePwd];
    self.pwdSwitchCtrl = [[UISwitch alloc] initWithFrame:CGRectMake(320, 505, 120, 30)];
    pwdSwitchCtrl.on = NO;
    [self.view addSubview:pwdSwitchCtrl];
    
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.reversesTitleShadowWhenHighlighted = YES;
    btnLogin.showsTouchWhenHighlighted = YES;
    [btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.frame = CGRectMake(468, 400, 115, 105);
    [self.view addSubview:btnLogin];
       
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSString* str = NSStringFromCGPoint(self.changeScrollView.contentOffset);
     int offsetY = -scrollView.contentOffset.y;
    self.lineView.frame = CGRectMake(60, -offsetY, 3, offsetY);
    //NSLog(@"changeScrollView 的滑动偏移量 %@",str);
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= -30)
    {
        NSString* skinColor = [[NSUserDefaults standardUserDefaults] objectForKey:KSkinColor];
        
        if ([skinColor isEqualToString:@"green"] ){
            [[NSUserDefaults standardUserDefaults] setObject:@"blue" forKey:KSkinColor];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"green" forKey:KSkinColor];
        }
        
        [self changeThemeColor];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{

    self.changeScrollView.contentOffset = CGPointZero;
}

-(void)changeThemeColor
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.75;
    animation.type = kCATransitionFade;
    
   [self configSkins];
    
[self.view.layer addAnimation:animation forKey:@"animation"];

   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addUIViews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:KUserName];
	if (usr == nil) usr= @"";
	usrField.text = usr;
    
    NSString* savePwd = [defaults objectForKey:KSavePwd];
    if([savePwd isEqualToString:@"1"]){
        NSString *pwd = [defaults objectForKey:KUserPassword];
        if([pwd length] > 0)
            pwdField.text = pwd;
        pwdSwitchCtrl.on = YES;
    }else
        pwdSwitchCtrl.on = NO;
    
}


-(void)login:(id)sender
{
    
    NSString *msg = @"";
    if ([usrField.text isEqualToString:@""] || usrField.text.length <= 0)
    {
        msg = @"用户名不能为空";
    }
    else if([pwdField.text isEqualToString:@""]  || pwdField.text.length <= 0)
    {
        msg = @"密码不能为空";
    }
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"SYSTEM_USER_LOGIN" forKey:@"service"];
    [params setObject:usrField.text forKey:@"user_login_id"];
    
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicUser setObject:pwdField.text forKey:@"password"];
    [dicUser setObject:usrField.text forKey:@"userId"];
    
    NSString *lastSyncDate = [[NSUserDefaults standardUserDefaults] stringForKey:kLoginSyncDate];
    if(lastSyncDate == nil || [lastSyncDate length] <= 0)
        lastSyncDate = @"2008-08-08 18:18:18.888";
    [params setObject:lastSyncDate forKey:@"syncDate"];
    [[SystemConfigContext sharedInstance] setUser:dicUser];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在登录中..." tagID:0] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self configSkins];
    
    //清空密码
    NSString* savePwd = [[NSUserDefaults standardUserDefaults] objectForKey:KSavePwd];
    if([savePwd isEqualToString:@"1"]){
        
        pwdSwitchCtrl.on = YES;
    }else{
        pwdSwitchCtrl.on = NO;
        pwdField.text = @"";
    }
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        NSString *msg = @"登录失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"1登录获得数据为：%@",resultJSON);
    BOOL bFailed = NO;
    id obj = [resultJSON objectFromJSONString];
    if(![obj isKindOfClass:[NSDictionary class]])
    {
        
        bFailed = YES;
    }
    else
    {

        NSDictionary *dicResult = [resultJSON objectFromJSONString];

        if (dicResult && [dicResult count] > 0)
        {
            NSString *msg = [dicResult objectForKey:@"MSG"] ;
            if(msg && [msg length] > 0){
                
                msg = @"用户名或密码错误，请重新输入！";
                [self showAlertMessage:msg];
                return;
            }
            NSDictionary *dicUserInfo = [dicResult objectForKey:@"user"];
            if (dicUserInfo && [dicUserInfo count] > 0)
            {
                NSString *usr = usrField.text;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:usr forKey:KUserName];
                [defaults setObject:pwdField.text forKey:KUserPassword];
                if (pwdSwitchCtrl.on)
                    [defaults setObject:@"1" forKey:KSavePwd];
                else
                    [defaults setObject:@"0" forKey:KSavePwd];
                [defaults synchronize];
                
                NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
                [dicUser setObject:pwdField.text forKey:@"password"];
                [dicUser setObject:usr forKey:@"userId"];
                [dicUser setObject:[dicUserInfo objectForKey:@"YHMC"] forKey:@"uname"];
                [dicUser setObject:[dicUserInfo objectForKey:@"BMBH"] forKey:@"depart"];
                [dicUser setObject:[dicUserInfo objectForKey:@"ORGID"] forKey:@"orgid"];
                [dicUser setObject:[dicUserInfo objectForKey:@"SJQX"] forKey:@"sjqx"];//数据权限
                [[SystemConfigContext sharedInstance] setUser:dicUser];
              
                MenuHelper *helper = [[MenuHelper alloc] init];
                //处理菜单信息
                NSArray *aryAllMenus = [dicResult objectForKey:@"allMenus"];
                if(aryAllMenus && [aryAllMenus count] > 0)
                    [helper processAllMenus:aryAllMenus];
                NSArray *arySyncYhcds = [dicResult objectForKey:@"syncYhcds"];
                if(arySyncYhcds && [arySyncYhcds count] > 0)
                    [helper processSyncYhcds:arySyncYhcds];
                NSArray *aryDelYhcds = [dicResult objectForKey:@"delYhcds"];
                if(aryDelYhcds && [aryDelYhcds count] > 0)
                    [helper processDelYhcds:aryDelYhcds];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *now = [NSDate date];
                NSString *currentSyncTime = [df stringFromDate:now];
                [[NSUserDefaults standardUserDefaults] setObject:currentSyncTime forKey:kLoginSyncDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //跳转到主菜单界面
                MainMenuViewController *menuController= [[MainMenuViewController alloc] init];
                [self.navigationController pushViewController:menuController animated:YES];
            }
         /*   else if(status == -1)
            {
                UILabel *udidLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 600, 468, 120)];
                udidLabel.backgroundColor = [UIColor clearColor];
                udidLabel.textColor = [UIColor redColor];
                udidLabel.font = [UIFont systemFontOfSize:22.0];
                udidLabel.numberOfLines = 0;
                udidLabel.text = [NSString stringWithFormat: @"此设备未与所登录的用户绑定。如需绑定，请联系维护人员并提供以下设备号：\n   %@", [[SystemConfigContext sharedInstance] getDeviceID]];
                [self.view addSubview:udidLabel];
                
                return;
            }*/
            
        }
        else
        {
            bFailed = YES;
        }
        
    }
    if (bFailed)
    {
        [self showAlertMessage:@"登录失败"];
        return;
    }
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
   
    return;
}

-(void)gotoMainMenu{
    MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:menuController animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
}
@end
