//
//  MapViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 14-6-4.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapClipDelegate  

-(void)returnClipedImage:(UIImage*)img;

@end

@interface MapViewController : UIViewController
@property(nonatomic,assign)id<MapClipDelegate> delegate;
@end
