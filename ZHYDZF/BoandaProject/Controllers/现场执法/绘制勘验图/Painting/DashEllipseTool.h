//
//  DashEllipseTool.h
//  虚线椭圆
//
//  Created by power humor on 12-1-6.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface DashEllipseTool : NSObject <Tool>

@property (nonatomic, assign) id<ToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;

+(DashEllipseTool*)sharedDashEllipseTool;

@end
