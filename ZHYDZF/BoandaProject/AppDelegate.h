//
//  AppDelegate.h
//  BoandaProject
//
//  Created by 张仁松 on 13-6-26.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    time_t timeEnterBackground;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@end
