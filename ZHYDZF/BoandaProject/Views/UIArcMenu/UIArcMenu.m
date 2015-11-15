//
//  UIArcMenu.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIArcMenu.h"

@implementation UIArcMenu
//527 719
- (id)initWithFrame:(CGRect)frame andTarget:(id)target andSelector:(SEL)selector
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.image = [UIImage imageNamed:@"arcmenu_expand.png"];
        [self addSubview:imgView];
        
        CGRect rect0 = CGRectMake(35, 187, 55, 55);
        CGRect rect1 = CGRectMake(61, 131, 55, 55);
        CGRect rect2 = CGRectMake(106, 78, 55, 55);
        CGRect rect3 = CGRectMake(181, 70, 55, 55);
        CGRect rect4 = CGRectMake(180, 180, 60, 60);
        
        
        UIButton *btn0 = [[UIButton alloc] initWithFrame:rect0];
        [btn0 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn0.tag = 1;
        [self addSubview:btn0];
     
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:rect1];
        [btn1 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        btn1.tag = 2;
       
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:rect2];
        [btn2 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 3;
        [self addSubview:btn2];        
                
        UIButton *btn3 = [[UIButton alloc] initWithFrame:rect3];
        [btn3 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn3.tag = 4;
        [self addSubview:btn3];
       
        
        UIButton *btn4 = [[UIButton alloc] initWithFrame:rect4];
        [btn4 addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn4.tag = 5;
        [self addSubview:btn4];
       
        
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)arcMenuBtnPressed:(id)sender{
    NSLog(@"arcMenuBtnPressed");
}

@end
