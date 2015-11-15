//
//  ShowImageVC.m
//  BoandaProject
//
//  Created by PowerData on 14-6-9.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "ShowImageVC.h"

@interface ShowImageVC ()
@end

@implementation ShowImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame imagePath:(NSString *)path
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.imagePath = path;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"手写签批";
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backBarBtn:)];
    self.navigationItem.rightBarButtonItem = backBarBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webHelper = [[NSURLConnHelper alloc]initWithUrl:[NSString stringWithFormat:@"http://61.164.73.82:8090%@",self.imagePath] andParentView:self.view delegate:self];
}

-(void)backBarBtn:(UIBarButtonItem *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)processWebData:(NSData *)webData{
    self.imageView.image = [UIImage imageWithData:webData];
    self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width,self.imageView.image.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
