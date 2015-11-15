//
//  CustomIconsView.m
//  GMEPS_HZ
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomIconsView.h"
#import "BarBackgroundLayer.h"
#import "UIIconItem.h"

@implementation CustomIconsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.itemCount = 0;
        [self setBackgroundLayer:[[BarBackgroundLayer alloc] init]];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

-(void)addIconItem:(UIIconItem*)item
{
    float btnWidth = 70.0f,btnGap = 15.0f,btnHeight = 70.0f;
    item.tag = self.itemCount;
    item.frame = CGRectMake(btnWidth*self.itemCount + btnGap, btnGap, btnWidth, btnHeight);
    [self addSubview:item];
    self.itemCount++;
}

- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
{
    CALayer * oldBackground = [[self.layer sublayers] objectAtIndex:0];
    if (oldBackground)
    {
        [self.layer replaceSublayer:oldBackground with:backgroundLayer];
    }
    else
    {
        [self.layer insertSublayer:backgroundLayer atIndex:0];
    }
}

@end
