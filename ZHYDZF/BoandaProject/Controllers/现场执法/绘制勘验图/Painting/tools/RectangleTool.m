//
//  RectangleTool.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "RectangleTool.h"
#import "PathDrawingInfo.h"

@implementation RectangleTool

+(RectangleTool*)sharedRectangleTool
{
    static RectangleTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[RectangleTool alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
  if ((self = [super init])) {
    self.trackingTouches = [NSMutableArray arrayWithCapacity:100];
    self.startPoints = [NSMutableArray arrayWithCapacity:100];
  }
  return self;
}

- (void)activate {
}

-(void)deleteLastPoint:(BOOL)isDelete{
}

- (void)deactivate {
  [self.trackingTouches removeAllObjects];
  [self.startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // remember the touch, and its original start point, for future
    [self.trackingTouches addObject:touch];
    CGPoint location = [touch locationInView:touchedView];
    [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // make a rect from the start point to the current point
    NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
      PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:self.delegate.fillColor strokeColor:self.delegate.strokeColor];
      [self.delegate addDrawable:info];
      [self.trackingTouches removeObjectAtIndex:touchIndex];
      [self.startPoints removeObjectAtIndex:touchIndex];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)drawTemporary {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (int i = 0; i<[self.trackingTouches count]; i++) {
    UITouch *touch = [self.trackingTouches objectAtIndex:i];
    CGPoint startPoint = [[self.startPoints objectAtIndex:i] CGPointValue];
    CGPoint endPoint = [touch locationInView:touchedView];
    CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [self.delegate.fillColor setFill];
    [path fill];
    [self.delegate.strokeColor setStroke];
    [path stroke];
  }
}


@end
