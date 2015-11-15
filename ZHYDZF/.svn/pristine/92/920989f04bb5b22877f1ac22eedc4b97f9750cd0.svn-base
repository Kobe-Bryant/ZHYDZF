//
//  FreehandTool.m
//  Dudel
//
//  Created by JN on 2/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "FreehandTool.h"
#import "PathDrawingInfo.h"

@implementation FreehandTool

@synthesize delegate, workingPath;

+(FreehandTool*)sharedFreehandTool
{
    static FreehandTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[FreehandTool alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
  if ((self = [super init]))
  {
      
  }
  return self;
}

- (void)activate {
  self.workingPath = [UIBezierPath bezierPath];
  self.settingFirstPoint = YES;
}

-(void)deleteLastPoint:(BOOL)isDelete{
}

- (void)deactivate {
  // this is where we finally tell about our path
  PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:self.workingPath fillColor:delegate.fillColor strokeColor:delegate.strokeColor];
  [delegate addDrawable:info];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.isDragging = YES;
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  // set nextSegmentPoint2
  self.nextSegmentPoint2 = touchPoint;
  // establish nextSegmentCp2
  self.nextSegmentCp2 = touchPoint;
  if (workingPath.empty) {
    // this is the first touch in a path, so set the "1" variables as well
    self.nextSegmentCp1 = touchPoint;
    self.nextSegmentPoint1 = touchPoint;
    [workingPath moveToPoint:touchPoint];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  self.isDragging = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  self.isDragging = NO;
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  self.nextSegmentCp2 = touchPoint;
  // complete segment and add to list.
  if (self.settingFirstPoint) {
    // the first touch'n'drag doesn't complete a segment, we just
    // note the change of state and move along
    self.settingFirstPoint = NO;
  } else {
    // nextSegmentCp2, which we've
    // been dragging around, is translated around nextSegmentPoint2 
    // for creation of this segment.
    CGPoint shiftedNextSegmentCp2 = CGPointMake(self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x),self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
    [workingPath addCurveToPoint:self.nextSegmentPoint2 controlPoint1:self.nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
    // the "2" values are now copied to the "1" variables
    self.nextSegmentPoint1 = self.nextSegmentPoint2;
    self.nextSegmentCp1 = self.nextSegmentCp2;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  if (self.settingFirstPoint) {
    self.nextSegmentCp1 = touchPoint;
  } else {
    // adjust nextSegmentCp2
    self.nextSegmentCp2 = touchPoint;
  }
}

- (void)drawTemporary
{
  // draw all the segments we've finished so far
  [workingPath stroke];
  if (self.isDragging)
  {
    // draw the current segment that's being created.
    if (self.settingFirstPoint)
    {
      // just draw a line
      UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
      [currentWorkingSegment moveToPoint:self.nextSegmentPoint1];
      [currentWorkingSegment addLineToPoint:self.nextSegmentCp1];
      [[delegate strokeColor] setStroke];
      [currentWorkingSegment stroke];
    }
    else
    {
      // nextSegmentCp2, which we've
      // been dragging around, is translated around nextSegmentPoint2 
      // for creation of this segment.      
      CGPoint shiftedNextSegmentCp2 = CGPointMake(self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x),self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
      UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
      [currentWorkingSegment moveToPoint:self.nextSegmentPoint1];
      [currentWorkingSegment addCurveToPoint:self.nextSegmentPoint2 controlPoint1:self.nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
      [[self.delegate strokeColor] setStroke];
      [currentWorkingSegment stroke];
    }
  }
  if (!CGPointEqualToPoint(self.nextSegmentCp2, self.nextSegmentPoint2) && !self.settingFirstPoint)
  {
    // draw the guideline to the next segment
    //CGContextSaveGState(UIGraphicsGetCurrentContext());
    UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
    [currentWorkingSegment moveToPoint:self.nextSegmentCp2];
    CGPoint shiftedNextSegmentCp2 = CGPointMake(self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x),self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
    [currentWorkingSegment addLineToPoint:shiftedNextSegmentCp2];
    float dashPattern[] = {10.0, 7.0};
    [currentWorkingSegment setLineDash:dashPattern count:2 phase:0.0];
    [[UIColor redColor] setStroke];
    [currentWorkingSegment stroke];    
    //CGContextRestoreGState(UIGraphicsGetCurrentContext());
  }
}

@end
