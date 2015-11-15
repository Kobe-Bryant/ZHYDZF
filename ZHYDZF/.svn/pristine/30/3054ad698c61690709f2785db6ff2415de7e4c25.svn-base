//
//  AppDelegate.m
//  BoandaProject
//
//  Created by 张仁松 on 13-6-26.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "AppDelegate.h"
#import "NdUncaughtExceptionHandler.h"
#import "LoginViewController.h"
#import "SystemConfigContext.h"
#import "CustomNavigationController.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   //捕捉异常，并做相应的处理
   // [NdUncaughtExceptionHandler setDefaultHandler];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    VP_InitSDK();
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    CustomNavigationController *nav =[[CustomNavigationController alloc] initWithRootViewController:loginController];
    self.navController = nav;
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoginSystem:) name:kReloginSystem object:nil];
    return YES;
}


-(void)reLoginSystem:(id)sender{
     [self performSelectorOnMainThread:@selector(gotoLogInUI) withObject:nil waitUntilDone:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    time(&timeEnterBackground);
}


-(void)gotoLogInUI{
	

    [self.navController popToRootViewControllerAnimated:NO];
   
    [self.window makeKeyAndVisible];
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    time_t now;
    time(&now);
//    NSLog(@"%ld",now - timeEnterBackground);
    if ((now - timeEnterBackground) >  5*60){//超过5分钟就重新登录
  
        
        [self performSelectorOnMainThread:@selector(gotoLogInUI) withObject:nil waitUntilDone:NO];

    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[SystemConfigContext sharedInstance] readSettings];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
