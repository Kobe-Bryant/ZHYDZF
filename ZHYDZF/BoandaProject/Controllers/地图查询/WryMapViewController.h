//
//  WryMapViewController.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//http://10.19.67.48/ArcGIS/rest/services/WhuMap/MapServer
//http://10.34.254.20/ArcGIS/rest/services/zhrest/MapServer

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NSURLConnHelper.h"
#import "CoreLocationController.h"
#import "BaseViewController.h"
#import <ArcGIS/ArcGIS.h>
#define kTiledMapServiceURL @"http://www.nbmap.gov.cn/ArcGIS/rest/services/mapall/MapServer"
//#define kTiledMapServiceURL @"http://10.34.254.20/ArcGIS/rest/services/zhrest/MapServer"

@interface WryMapViewController : BaseViewController<NSURLConnHelperDelegate,CoreLocationControllerDelegate,AGSCalloutDelegate,AGSMapViewCalloutDelegate>

@property(nonatomic,retain)AGSMapView *agsMapView;
@property(nonatomic,retain)AGSGraphicsLayer *graphicsLayer;
@property(nonatomic,strong)  NSURLConnHelper *urlConnHelper;
@property(nonatomic,retain)  NSArray *aryWryItems;
@property(nonatomic,retain) IBOutlet UITableView *listTableView;
@property(nonatomic,retain) IBOutlet UIButton *searchBtn;
@property(nonatomic,retain) IBOutlet UILabel *mcLabel;
@property(nonatomic,retain) IBOutlet UILabel *dzLabel;
@property(nonatomic,retain) IBOutlet UILabel *roundLabel;
@property(nonatomic,retain) IBOutlet UITextField *mcField;
@property(nonatomic,retain) IBOutlet UITextField *dzField;
@property(nonatomic,retain) IBOutlet UITextField *roundField;
@property (nonatomic, retain) CoreLocationController *CLController;
@property(nonatomic,assign)CLLocationCoordinate2D userCoordinate;
@property(nonatomic,assign) BOOL bHaveShow;
-(IBAction)searchWry:(id)sender;
@end
