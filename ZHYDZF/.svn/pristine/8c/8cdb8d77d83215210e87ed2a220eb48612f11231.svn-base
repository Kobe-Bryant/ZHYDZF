//
//  PencilTool.h
//  Dudel
//
//  Created by JN on 2/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface PencilTool : NSObject <Tool>

@property (nonatomic, assign) id <ToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *paths;

+(PencilTool*)sharedPencilTool;

@end
