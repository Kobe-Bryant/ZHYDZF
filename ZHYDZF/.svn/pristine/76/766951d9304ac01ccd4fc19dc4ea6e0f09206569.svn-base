//
//  ModifyWryLocViewController.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  坐标修改

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MovingImageView.h"

@interface ModifyWryLocViewController : UIViewController
<MKMapViewDelegate,MovingImageUpdateDelegate>
@property(nonatomic,copy) NSString *wrybh;
@property(nonatomic,copy) NSString *wrymc;
@property(nonatomic,strong) NSString *oldJD;
@property(nonatomic,strong) NSString *oldWD;

@property(nonatomic,retain) MKMapView* mapView;

@property(nonatomic,strong) MovingImageView *appointWryPosView;
@property(nonatomic,strong) UILabel *oldJWDLabel;
@property(nonatomic,strong) UILabel *appointJWDLabel;
@property(nonatomic,strong) NSString *toModifyJD;
@property(nonatomic,strong) NSString *toModifyWD;
@end
