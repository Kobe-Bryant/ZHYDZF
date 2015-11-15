//
//  ShowImageViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-6-6.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ShowImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithImagePath:(NSString *)path
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentSizeForViewInPopover = CGSizeMake(600, 200);
    
    self.webHelper = [[NSURLConnHelper alloc]initWithUrl:@"http://61.164.73.82:8090/zhbg//iWebRevision/iWebRevision.img/6344047364694460.gif" andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData *)webData{
    UIImage *image = [UIImage imageWithData:webData];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 600,200)];
    self.scrollView.contentSize = CGSizeMake(image.size.width,image.size.height);
    [self.view addSubview:self.scrollView];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image.size.width,image.size.height)];
    self.imageView.image = image;
    [self.scrollView addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
