//
//  MapViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 14-6-4.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "MapViewController.h"
#import "CoreLocationController.h"
#import <QuartzCore/QuartzCore.h>

@interface MapViewController ()<MKMapViewDelegate>
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)CoreLocationController *locController;
@end

@implementation MapViewController
@synthesize mapView,locController,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clipMap:(id)sender{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(mapView.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [mapView.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    [delegate returnClipedImage:image];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(clipMap:)];
	// Do any additional setup after loading the view.
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
	mapView.delegate = self;
	[self.view addSubview:mapView];
    
    mapView.showsUserLocation = YES;
   
    locController = [[CoreLocationController alloc] init];
	locController.delegate = self;
    [locController.locMgr startUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationUpdate:(CLLocation *)location {
	 
    mapView.centerCoordinate = location.coordinate;
}


- (void)locationError:(NSError *)error {
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (locController) {
        [locController.locMgr stopUpdatingLocation];
    }
 
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}



 
@end
