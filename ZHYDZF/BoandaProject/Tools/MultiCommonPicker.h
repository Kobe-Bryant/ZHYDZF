//
//  MultiCommonPicker.h
//  BoandaProject
//
//  Created by ZHONGWEN on 14-2-19.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getJCPCDelegate <NSObject>

- (void)returnJCPC:(NSString *)jcpcStr;
@end

@interface MultiCommonPicker : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *multiCommonView;
@property (assign, nonatomic) id<getJCPCDelegate> delegate;
@property (strong, nonatomic) NSArray *commonWords1;
@property (strong, nonatomic) NSArray *commonWords2;
@end
