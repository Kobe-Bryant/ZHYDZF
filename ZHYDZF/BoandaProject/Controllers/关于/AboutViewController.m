//
//  AboutViewController.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "OpinionViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.BBLabel.text = strVer;

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"确定"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)opinionBtnClick
{
    OpinionViewController *opinionNav = [[OpinionViewController alloc]init];
    [self.navigationController pushViewController:opinionNav animated:YES];
}

- (void)viewDidUnload
{
    [self setBBLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
