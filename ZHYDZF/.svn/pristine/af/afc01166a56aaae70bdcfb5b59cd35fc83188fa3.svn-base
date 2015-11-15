//
//  DashLineTool.m
//  GMEPS_HZ
//
//  Created by power humor on 12-1-5.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

//
//  LineTool.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DashLineTool.h"
#import "PathDrawingInfo.h"

@implementation DashLineTool

+(DashLineTool*)sharedDashLineTool
{
    static DashLineTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[DashLineTool alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.trackingTouches = [NSMutableArray arrayWithCapacity:100];
        self.startPoints = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (void)activate
{
    
}

-(void)deleteLastPoint:(BOOL)isDelete
{
    
}

- (void)deactivate
{
    [self.trackingTouches removeAllObjects];
    [self.startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches])
    {
        // remember the touch, and its original start point, for future
        [self.trackingTouches addObject:touch];
        ////NSLog(@"shuliang:%@",trackingTouches);
        CGPoint location = [touch locationInView:touchedView];
        [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)AddDashStyleToPath:(UIBezierPath*)thePath
{
    // Set the line dash pattern.
    float lineDash[6];
    lineDash[0] = 15.0;
    lineDash[1] = 15.0;
    lineDash[2] = 15.0;
    lineDash[3] = 15.0;
    lineDash[4] = 15.0;
    lineDash[5] = 15.0;
    [thePath setLineDash:lineDash count:6 phase:0.0];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches])
    {
        // make a line from the start point to the current point
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        // only if we actually remember the start of this touch...
        if (touchIndex != NSNotFound)
        {
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            [self AddDashStyleToPath:path];
            
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:self.delegate.fillColor strokeColor:self.delegate.strokeColor];
            [self.delegate addDrawable:info];
            [self.trackingTouches removeObjectAtIndex:touchIndex];
            [self.startPoints removeObjectAtIndex:touchIndex];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)drawTemporary
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (int i = 0; i<[self.trackingTouches count]; i++)
    {
        UITouch *touch = [self.trackingTouches objectAtIndex:i];
        CGPoint startPoint = [[self.startPoints objectAtIndex:i] CGPointValue];
        CGPoint endPoint = [touch locationInView:touchedView];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [self AddDashStyleToPath:path];
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        [self.delegate.strokeColor setStroke];
        [path stroke];
    }
}

@end

