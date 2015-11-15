//
//  EraserTool.h
//  Dudel
//
//  Created by chen on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface EraserTool : NSObject <Tool>

@property (nonatomic, assign) id<ToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *paths;

+(EraserTool*)sharedEraserTool;

@end
