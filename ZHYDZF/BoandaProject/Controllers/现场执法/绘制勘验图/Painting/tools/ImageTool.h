//
//  ImageTool.h
//  GMEPS_HZ
//
//  Created by zhang on 11-10-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface ImageTool : NSObject <Tool>

@property (nonatomic,assign)id <ToolDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *trackingTouches;
@property (nonatomic,strong) NSMutableArray *startPoints;
@property (nonatomic,assign) CGRect ImgRect;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,assign) BOOL bAnotherImg;//yes表示再次点击按钮图标

+(ImageTool*)sharedImageTool;

@end
