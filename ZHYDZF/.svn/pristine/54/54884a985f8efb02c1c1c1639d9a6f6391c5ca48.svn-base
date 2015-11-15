//
//  FreehandTool.h
//  Dudel
//
//  Created by JN on 2/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface FreehandTool : NSObject <Tool>

@property (assign, nonatomic) id <ToolDelegate> delegate;
@property (strong, nonatomic) UIBezierPath *workingPath;
@property (assign, nonatomic) CGPoint nextSegmentPoint1;
@property (assign, nonatomic) CGPoint nextSegmentPoint2;
@property (assign, nonatomic) CGPoint nextSegmentCp1;
@property (assign, nonatomic) CGPoint nextSegmentCp2;
@property (assign, nonatomic) BOOL isDragging;
@property (assign, nonatomic) BOOL settingFirstPoint;

+(FreehandTool*)sharedFreehandTool;

@end
