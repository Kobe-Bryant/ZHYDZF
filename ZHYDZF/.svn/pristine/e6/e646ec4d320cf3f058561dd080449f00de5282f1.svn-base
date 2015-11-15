//
//  ChangePwdViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-12-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)okBtnClick
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(okBtnClick)];
   self.navigationItem.rightBarButtonItem = commitButton;
    
    oldPwdField.secureTextEntry = YES;
    newPwdField.secureTextEntry = YES;
    againPwdField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePwd:(id)sender{
    if(![newPwdField.text isEqualToString:againPwdField.text]){
        infoLabel.text = @"输入的两个新密码不一致！";
        return;
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    if(![oldPwdField.text isEqualToString:[loginUsr objectForKey:@"password"]]){
        infoLabel.text = @"输入的原始密码不正确！";
        return;
    }
                        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"MODIFY_USER_PASS" forKey:@"service"];
    [params setObject:[loginUsr objectForKey:@"userId"] forKey:@"user_login_id"];
    [params setObject:newPwdField.text forKey:@"newword"];
 
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在修改密码..." tagID:0] ;
}

-(void)processWebData:(NSData*)webData
{
    NSString *msg = @"密码修改成功，您必须使用新密码重新登陆系统。";
    [self showAlertMessage:msg];
}

-(void)processError:(NSError *)error{
    infoLabel.text = @"请求数据失败,请检查网络。";
    
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      [[NSNotificationCenter defaultCenter] postNotificationName:kReloginSystem object:nil];
     [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
