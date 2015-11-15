//
//  ChooseTimeRangeVC.h
//  MonitorPlatform
//
//  Created by 王哲义 on 12-9-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseTimeRangeDelegate
-(void)choosedFromTime:(NSString *)fromTime andEndTime:(NSString *)endTime andType:(NSString *)type;
-(void)cancelSelectTimeRange;
@end

@interface ChooseTimeRangeVC : UIViewController


@property (nonatomic,assign) id<ChooseTimeRangeDelegate> delegate;

@property (nonatomic,strong)  UIDatePicker *theDP;
@property (nonatomic,strong)  UIDatePicker *theSP;
@property (nonatomic,strong)UISegmentedControl *segCtrl;
@property (nonatomic,assign) BOOL segCtrlHidden;

@end
