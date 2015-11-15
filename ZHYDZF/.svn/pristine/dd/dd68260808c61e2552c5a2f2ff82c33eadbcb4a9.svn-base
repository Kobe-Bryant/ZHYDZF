//
//  SetViewController.h
//  BoandaProject
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeSkinController;
@protocol SetViewControllerDelegate <NSObject>

@optional
-(void)changeSkin;
@end
@interface ChangeSkinController : UIViewController
@property(nonatomic ,assign)id <SetViewControllerDelegate> delegate;
-(IBAction)changeTheme:(id)sender;
@end
