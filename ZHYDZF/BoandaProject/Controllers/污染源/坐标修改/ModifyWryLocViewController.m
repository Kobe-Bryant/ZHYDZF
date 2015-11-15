//
//  ModifyWryLocViewController.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyWryLocViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "ModifyTipViewController.h"

@interface ModifyWryLocViewController ()

@end

@implementation ModifyWryLocViewController
@synthesize wrybh,wrymc,appointWryPosView;
@synthesize mapView,appointJWDLabel,oldJWDLabel;
@synthesize toModifyJD,toModifyWD,oldJD,oldWD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)handleTap:(UITapGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded)     { 
        
        CGPoint pt = [sender locationInView:mapView];
        appointWryPosView.center = pt;
        CLLocationCoordinate2D coor = [mapView convertPoint:pt toCoordinateFromView:mapView];
        
        self.toModifyWD = [NSString stringWithFormat:@"%f",coor.latitude];
        self.toModifyJD = [NSString stringWithFormat:@"%f",coor.longitude];
        
        appointJWDLabel.text = [NSString stringWithFormat:@"指定经度：%f       指定纬度：%f",coor.longitude,coor.latitude];
    }
}

-(void)didUpdateViewPos{
    CGPoint pt = appointWryPosView.center;
    CLLocationCoordinate2D coor = [mapView convertPoint:pt toCoordinateFromView:mapView];
    // NSLog(@"pt:%f %f",coor.latitude,coor.longitude);
    self.toModifyWD = [NSString stringWithFormat:@"%f",coor.latitude];
    self.toModifyJD = [NSString stringWithFormat:@"%f",coor.longitude];
    
    appointJWDLabel.text = [NSString stringWithFormat:@"指定经度：%f       \n指定纬度：%f",coor.longitude,coor.latitude];
}

-(void)modifyLocation:(id)sender{
    
    ModifyTipViewController *tipController = [[ModifyTipViewController alloc] initWithNibName:@"ModifyTipViewController" bundle:nil];
    tipController.oldJD = oldJD;
    tipController.oldWD = oldWD;
    tipController.toModifyJD = toModifyJD;
    tipController.toModifyWD = toModifyWD;
    tipController.wrybh = wrybh;
    tipController.wrymc = wrymc;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tipController];
    
    nav.modalPresentationStyle =  UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    nav.view.superview.frame = CGRectMake(30, 100, 320, 480);
    nav.view.superview.center = self.view.center;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = wrymc;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"提交坐标" style:UIBarButtonItemStyleDone target:self action:@selector(modifyLocation:)];
    self.navigationItem.rightBarButtonItem = button;

    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
	mapView.delegate = self;
	[self.view addSubview:mapView];
    mapView.showsUserLocation = YES;
    
    
    CLLocationCoordinate2D hangzhouCoor;
    hangzhouCoor.latitude = [self.oldWD doubleValue];
    hangzhouCoor.longitude = [self.oldJD doubleValue];
    oldJD = [NSString stringWithFormat:@"%f",hangzhouCoor.longitude];
    oldWD = [NSString stringWithFormat:@"%f",hangzhouCoor.latitude];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(hangzhouCoor, 100000,100000);
    
    [mapView setRegion:region animated:YES];
    mapView.centerCoordinate = hangzhouCoor;
    mapView.showsUserLocation = YES;
    
    UIView *tipBgView = [[UIView alloc] initWithFrame:CGRectMake(565, 3, 200, 130)];
    tipBgView.backgroundColor = [UIColor lightGrayColor];
    tipBgView.layer.cornerRadius = 4.0;
    tipBgView.alpha = 0.9f;
    [self.view addSubview:tipBgView];
    
    oldJWDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    oldJWDLabel.numberOfLines = 2;
    oldJWDLabel.backgroundColor = [UIColor clearColor];
    oldJWDLabel.textColor = [UIColor orangeColor];
    [tipBgView addSubview:oldJWDLabel];
    appointJWDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 200, 50)];
    appointJWDLabel.numberOfLines = 2;
    appointJWDLabel.backgroundColor = [UIColor clearColor];
    appointJWDLabel.textColor = [UIColor orangeColor];
    [tipBgView addSubview:appointJWDLabel];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
    tipLabel.numberOfLines = 2;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.text = @"提示：拖动红旗设置新坐标";
    [tipBgView addSubview:tipLabel];
    
    // 添加一个PointAnnotation
     oldJWDLabel.text = [NSString stringWithFormat:@"原经度：%@ \n原纬度：%@",oldJD,oldWD];
    
    if ([oldJD length] >0 && [oldWD length] > 0)
    {
        CLLocationCoordinate2D wrycoor ;
        wrycoor.latitude = [oldWD floatValue];
        wrycoor.longitude = [oldJD floatValue];
        
//        annotation.coordinate = wrycoor;
//        annotation.wrybh = wrybh;
//        annotation.wrymc = wrymc;
//        annotation.title = @"污染源";
//        annotation.subtitle = wrymc;
//        [mapView addAnnotation:annotation];
      
    }
   
    
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [mapView addGestureRecognizer:tapGesture];

    self.appointWryPosView = [[MovingImageView alloc] initWithImage:[UIImage imageNamed:@"flag.png"]];
    appointWryPosView.userInteractionEnabled = YES;
    appointWryPosView.delegate = self;
    appointWryPosView.center = self.view.center;
    [mapView addSubview:appointWryPosView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



// Override
// Override




@end
