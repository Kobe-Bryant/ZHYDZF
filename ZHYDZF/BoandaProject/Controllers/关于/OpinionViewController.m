//
//  OpinionViewController.m
//  BoandaProject
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "OpinionViewController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "JSONKit.h"

@interface OpinionViewController ()
@property(nonatomic,strong)IBOutlet UITextView *opinionTV;
@property(nonatomic,strong)IBOutlet UITextField *userTF;
@property(nonatomic,strong)IBOutlet UITextField *numbTF;
@property(nonatomic,strong)IBOutlet UITextField *emilTF;
@end
@implementation OpinionViewController

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
    
    [self.opinionTV becomeFirstResponder];
    self.navigationController.view.userInteractionEnabled = YES;
}


-(IBAction)commitBtnClick
{
    
    NSString *msg = @"";
    if ([self.opinionTV.text isEqualToString:@""] || self.opinionTV.text.length <= 0)
    {
        msg = @"意见不能为空";
    }
    else if([self.userTF.text isEqualToString:@""]  || self.userTF.text.length <= 0)
    {
        msg = @"联系人不能为空";
    }
    else if([self.numbTF.text isEqualToString:@""]  || self.numbTF.text.length <= 0)
    {
        msg = @"号码不能为空";
    }
    
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"TERMINAL_APLAY_OPINION" forKey:@"service"];    
    [params setObject:self.opinionTV.text forKey:@"FKNR"];
    [params setObject:self.userTF.text forKey:@"YJFKR"];
    [params setObject:self.numbTF.text forKey:@"FKRDH"];
    [params setObject:self.emilTF.text forKey:@"FKRLXFS"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"要反馈意见=%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在提交中..." tagID:0] ;
}
-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        NSString *msg = @"提交失败";
        [self showAlertMessage:msg];
        return;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"意见返回数据为：%@",resultJSON);
        
//        NSDictionary *dic = [resultJSON objectFromJSONString];
        JSONDecoder* json = [[JSONDecoder alloc]init];
        NSDictionary *dic = [json objectWithData:webData];
        NSString *str = [dic objectForKey:@"message"];
        [self showAlertMessage:str];
    }
}
//- (BOOL) disablesAutomaticKeyboardDismissal {
//    return NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
