//
//  UIIconItem.m
//  GMEPS_HZ
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIIconItem.h"

@implementation UIIconItem
@synthesize image;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIIconItem *)tabItemWithIcon:(UIImage *)icon
{
    
    UIIconItem * tabItem = [[UIIconItem alloc] init];
    [tabItem setImage:icon forState:UIControlStateNormal];
    tabItem.image = icon;
    return tabItem;
}

@end
