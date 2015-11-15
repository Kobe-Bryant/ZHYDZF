//
//  PathDrawingInfo.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PathDrawingInfo.h"

@implementation PathDrawingInfo

- (id)initWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s
{
    if ((self = [self init]))
    {
        self.path = p;
        self.fillColor = f;
        self.strokeColor = s;
    }
    return self;
}

+ (id)pathDrawingInfoWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s
{
    return [[self alloc] initWithPath:p fillColor:f strokeColor:s];
}

- (void)draw
{
    if (self.fillColor)
    {
        [self.fillColor setFill];
        [self.path fill];
    }
    if (self.strokeColor)
    {
        [self.strokeColor setStroke];
        [self.path stroke];
    }
}
@end
