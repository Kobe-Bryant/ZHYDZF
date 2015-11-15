//
//  ImgDrawingInfo.m
//  GMEPS_HZ
//
//  Created by zhang on 11-10-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImgDrawingInfo.h"

@implementation ImgDrawingInfo
    
- (id)initWithLocation:(CGPoint)pt andImage:(UIImage *)img
{
    if ((self = [super init]))
    {
        self.location = pt;
        self.image = img;
    }
    return self;
}

- (id)initWithLocation:(CGPoint)pt andSize:(CGSize)size andImage:(UIImage *)img
{
    if ((self = [self init]))
    {
        self.location = pt;
        self.imgSize = size;
        self.image = img;
    }
    return self;
}

- (void)draw
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageRect;
	imageRect.origin = CGPointMake(self.location.x - self.imgSize.width/2, self.location.y - self.imgSize.height/2);
	imageRect.size = self.imgSize;
	
    [self.image drawInRect:imageRect];
	//CGContextDrawImage(context, imageRect, image.CGImage);
}

@end
