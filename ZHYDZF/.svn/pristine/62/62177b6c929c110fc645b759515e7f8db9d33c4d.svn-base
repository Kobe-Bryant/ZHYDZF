//
//  ArrowDashLine.m
//  GMEPS_HZ
//
//  Created by Apple on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ArrowDashLine.h"
#import "PathDrawingInfo.h"

@implementation ArrowDashLine

@synthesize delegate;

+ (ArrowDashLine *)sharedArrowDashLine
{
    static ArrowDashLine *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[ArrowDashLine alloc] init];
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
    for (UITouch *touch in [event allTouches]) {
        // remember the touch, and its original start point, for future
        [self.trackingTouches addObject:touch];
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
    
    lineDash[0] = 8.0;
    lineDash[1] = 8.0;
    lineDash[2] = 8.0;
    lineDash[3] = 8.0;
    lineDash[4] = 8.0;
    lineDash[5] = 8.0;
    
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
            [self AddDashStyleToPath:path];
            
            double slopy , cosy , siny;
            double Par = 15.0;
            slopy = atan2((endPoint.y - startPoint.y), (endPoint.x - startPoint.x));
            cosy = cos( slopy );
            siny = sin( slopy ); 
            
            [path moveToPoint:endPoint];
            [path addLineToPoint:CGPointMake(endPoint.x - (Par*cosy - (Par/2.0*siny)),endPoint.y - (Par*siny + (Par/2.0*cosy)))];
            [path addLineToPoint:CGPointMake(endPoint.x -(Par*cosy + Par/2.0*siny ),endPoint.y + (Par/2.0*cosy - Par*siny))];
            [path addLineToPoint:endPoint];
            [path fill];
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:[UIColor blackColor] strokeColor:self.self.delegate.strokeColor];
            [delegate addDrawable:info];
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
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        [self AddDashStyleToPath:path];
        
        
        double slopy , cosy , siny;
        double Par = 15.0;  //length of Arrow (>)
        slopy = atan2( ( endPoint.y - startPoint.y), (endPoint.x - startPoint.x) );
        cosy = cos( slopy );
        siny = sin( slopy ); //need math.h for these functions
        
        /*/-------------similarly the the other end-------------/*/
        [path moveToPoint:endPoint];
        [path addLineToPoint:CGPointMake(endPoint.x - (Par*cosy - (Par/2.0*siny )),endPoint.y - (Par*siny + (Par/2.0*cosy)))];
        [path addLineToPoint:CGPointMake(endPoint.x -(Par*cosy + Par/2.0*siny ),endPoint.y + (Par/2.0*cosy - Par*siny))];
        [path addLineToPoint:endPoint];
        
        
        [self.delegate.strokeColor setStroke];
        [path stroke];
        [[UIColor blackColor] setFill];
        [path fill];
    }
    
}

@end
