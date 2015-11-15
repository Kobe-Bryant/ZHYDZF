//
//  PencilTool.m
//  Dudel
//
//  Created by JN on 2/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PencilTool.h"
#import "PathDrawingInfo.h"

@implementation PencilTool

+ (PencilTool *)sharedPencilTool
{
    static PencilTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[PencilTool alloc] init];
    }
    return _sharedInstance;
}

- init {
  if ((self = [super init])) {
    self.trackingTouches = [NSMutableArray array];
    self.startPoints = [NSMutableArray array];
    self.paths = [NSMutableArray array];
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
  [self.paths removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // remember the touch, and its original start point, for future
    [self.trackingTouches addObject:touch];
    CGPoint location = [touch locationInView:touchedView];
    [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:location];
    [path setLineWidth:self.delegate.strokeWidth];
    [path addLineToPoint:location];
    [self.paths addObject:path];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in [event allTouches]) {
    // make a line from the start point to the current point
    NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      UIBezierPath *path = [self.paths objectAtIndex:touchIndex];
      PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:[UIColor clearColor] strokeColor:self.delegate.strokeColor];
      [self.delegate addDrawable:info];
      [self.trackingTouches removeObjectAtIndex:touchIndex];
      [self.startPoints removeObjectAtIndex:touchIndex];
      [self.paths removeObjectAtIndex:touchIndex];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [self.delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // make a line from the start point to the current point
    NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      CGPoint location = [touch locationInView:touchedView];
      UIBezierPath *path = [self.paths objectAtIndex:touchIndex];
      [path addLineToPoint:location];
    }
  }
}

- (void)drawTemporary {
  for (UIBezierPath *path in self.paths) {
    [self.delegate.strokeColor setStroke];
    [path stroke];
  }
}


@end
