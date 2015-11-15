//
//  ArrowDashLine.h
//  虚线箭头
//
//  Created by Apple on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface ArrowDashLine : NSObject <Tool>

@property (nonatomic, assign) id<ToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;

+(ArrowDashLine*)sharedArrowDashLine;

@end

