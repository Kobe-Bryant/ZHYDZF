//
//  DashEllipseTool.m
//  GMEPS_HZ
//
//  Created by power humor on 12-1-6.
//  Copyright (c) 2012年 powerdata. All rights reserved.
//

#import "DashEllipseTool.h"
#import "PathDrawingInfo.h"

@implementation DashEllipseTool

@synthesize delegate;

+ (DashEllipseTool *)sharedDashEllipseTool
{
    static DashEllipseTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[DashEllipseTool alloc] init];
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

-(void)AddDashStyleToPath:(UIBezierPath*)thePath
{
    float lineDash[6];
    lineDash[0] = 15.0;
    lineDash[1] = 15.0;
    lineDash[2] = 15.0;
    lineDash[3] = 15.0;
    lineDash[4] = 15.0;
    lineDash[5] = 15.0;
    [thePath setLineDash:lineDash count:6 phase:0.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches])
    {
        [self.trackingTouches addObject:touch];
        CGPoint location = [touch locationInView:touchedView];
        [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches])
    {
        // make a line from the start point to the current point
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        // only if we actually remember the start of this touch...
        if (touchIndex != NSNotFound)
        {
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
            [self AddDashStyleToPath:path];
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:delegate.fillColor strokeColor:delegate.strokeColor];
            [delegate addDrawable:info];
            [self.trackingTouches removeObjectAtIndex:touchIndex];
            [self.startPoints removeObjectAtIndex:touchIndex];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)drawTemporary
{
    UIView *touchedView = [delegate viewForUseWithTool:self];
    for (int i = 0; i<[self.trackingTouches count]; i++)
    {
        UITouch *touch = [self.trackingTouches objectAtIndex:i];
        CGPoint startPoint = [[self.startPoints objectAtIndex:i] CGPointValue];
        CGPoint endPoint = [touch locationInView:touchedView];
        CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [self AddDashStyleToPath:path];
        [delegate.fillColor setFill];
        [path fill];
        [delegate.strokeColor setStroke];
        [path stroke];
    }
}

@end

