//
//  MenuControl.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuControl : UIControl
@property(nonatomic,strong)NSDictionary *menuInfo;
@property(nonatomic,strong)UIButton *pressBtn;
-(void)showIconBadge:(NSString *)valueBadge;

-(id)initWithFrame:(CGRect)frame andMenuInfo:(NSDictionary*)menuInfo;

//add yes加号 no 减号
-(void)addShakeBadge:(BOOL)add;
-(void)removeShakeBadge;

-(void)addLongPressTarget:(id)target  andAction:(SEL)aSelector;

@end
