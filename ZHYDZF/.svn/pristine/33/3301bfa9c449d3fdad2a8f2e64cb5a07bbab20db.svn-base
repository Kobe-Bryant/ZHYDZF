//
//  SetViewController.m
//  BoandaProject
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ChangeSkinController.h"

@interface ChangeSkinController (){
    BOOL isGreen;
}

@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)IBOutlet UIButton *blueBtn;
@property(nonatomic,strong)IBOutlet UIButton *greenBtn;
@end

@implementation ChangeSkinController
@synthesize delegate;

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
    
    
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"确定"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(okBtnClick)];
    self.navigationItem.rightBarButtonItem = commitButton;
    
    NSString* skinColor = [[NSUserDefaults standardUserDefaults] objectForKey:KSkinColor];
    
    if ([skinColor isEqualToString:@"green"] )
    {
        self.blueBtn.imageView.image = [UIImage imageNamed:@"menuBg.jpg"];
        self.greenBtn.imageView.image = [UIImage imageNamed:@"menuBg_greenOK.png"];
        isGreen = YES;
        
    }
    else
    {
        self.blueBtn.imageView.image = [UIImage imageNamed:@"menuBgOK.png"];
        self.greenBtn.imageView.image = [UIImage imageNamed:@"menuBg_green.jpg"];
        isGreen = NO;
    }
    
}

-(IBAction)changeTheme:(id)sender
{
    
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1)
    {
        isGreen = NO;
        [self.blueBtn setImage:[UIImage imageNamed:@"menuBgOK.png"] forState:UIControlStateNormal];
        [self.greenBtn setImage:[UIImage imageNamed:@"menuBg_green.jpg"] forState:UIControlStateNormal];
    }
    else if (btn.tag == 2)
    {
        isGreen = YES;
        [self.blueBtn setImage:[UIImage imageNamed:@"menuBg.jpg"] forState:UIControlStateNormal];
        [self.greenBtn setImage:[UIImage imageNamed:@"menuBg_greenOK.png"] forState:UIControlStateNormal];
    }
}

-(void)okBtnClick
{
    if (isGreen) {
        [[NSUserDefaults standardUserDefaults] setObject:@"green" forKey:KSkinColor];
    }else
        [[NSUserDefaults standardUserDefaults] setObject:@"blue" forKey:KSkinColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinChanged object:nil];
    
   
    [self.navigationController dismissModalViewControllerAnimated:YES];

}

- (void)cancel:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
