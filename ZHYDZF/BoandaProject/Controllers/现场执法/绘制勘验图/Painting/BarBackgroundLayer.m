//  Created by Jason Morrissey

#import "BarBackgroundLayer.h"
#import "UIColor+Hex.h"

@implementation BarBackgroundLayer

-(id)init
{
    self = [super init];
    if (self)
    {
        CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
        UIColor * startColor = [UIColor lightGrayColor];
        UIColor * endColor = [UIColor colorWithHex:0x4a4b4a];
        gradientLayer.frame = CGRectMake(0, 0, 1024, 85);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
        [self insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

@end
