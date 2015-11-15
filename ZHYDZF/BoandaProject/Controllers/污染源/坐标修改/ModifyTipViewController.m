//
//  ModifyTipViewController.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyTipViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"

@interface ModifyTipViewController ()

@end

@implementation ModifyTipViewController
@synthesize urlConnHelper,wrymc,wrybh;
@synthesize oldJD,oldWD,toModifyJD,toModifyWD;
@synthesize oldJDField,oldWDField,toModifyJDField,toModifyWDField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - URLConnHelper delegate
-(void)processWebData:(NSData*)webData
{
      NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSMutableString *str = [NSMutableString stringWithString:resultJSON];
    
    [str replaceOccurrencesOfString:@"'" withString:@"\"" options:0 range:NSMakeRange(0, [str length])];
    
    NSDictionary *dicData = [str objectFromJSONString];

    if ([[dicData objectForKey:@"result"] boolValue]) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"校准坐标成功！" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];

    return;
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = wrymc;
    oldWDField.text = oldWD;
    oldJDField.text = oldJD;
    toModifyWDField.text = toModifyWD;
    toModifyJDField.text = toModifyJD;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"取消"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = backButton;
 
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)modifyLocation:(id)sender{
    
    if (toModifyJD.length != 0 && toModifyWD.length != 0){
    
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"MODIFY_WRY_LOCATION" forKey:@"service"];
        [params setObject:wrybh forKey:@"wrybh"];
        [params setObject:toModifyJD forKey:@"jd"];
        [params setObject:toModifyWD forKey:@"wd"];
        
        NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
        
        self.urlConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    }else{
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"纬度和经度无校准新值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)viewWillDisappear:(BOOL)animated{
    if (urlConnHelper) {
        [urlConnHelper cancel];
    }
    [super viewWillDisappear:animated];
}


-(void)dealloc{
    
   
}
@end
