//
//  BackgroundDrawingInfo.m
//  背景图
//
//  Created by  on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundDrawingInfo.h"

@implementation BackgroundDrawingInfo

@synthesize image;

- (id)initWithImage:(UIImage *)img
{
    if (self = [super init])
    {
        self.image = img;
    }
    return self;
}

- (void)draw
{
    CGRect imageRect;
	imageRect.origin = CGPointMake(0.0f, 0.0f);
	imageRect.size = self.image.size;
    [self.image drawInRect:imageRect];
}

@end

