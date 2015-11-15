//
//  DashLineTool.h
//  GMEPS_HZ
//
//  Created by power humor on 12-1-5.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface DashLineTool : NSObject <Tool>

@property (nonatomic, assign) id<ToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;

+(DashLineTool*)sharedDashLineTool;

@end