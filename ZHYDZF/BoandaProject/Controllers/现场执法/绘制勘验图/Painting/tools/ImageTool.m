//
//  ImageTool.m
//  GMEPS_HZ
//
//  Created by zhang on 11-10-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageTool.h"
#import "PathDrawingInfo.h"
#import "ImgDrawingInfo.h"

@implementation ImageTool

+ (ImageTool *)sharedImageTool
{
    static ImageTool *_sharedInstance = nil;
    @synchronized(self)
    {
        _sharedInstance = [[ImageTool alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
	if ((self = [super init]))
    {
		self.trackingTouches = [NSMutableArray array];
		self.startPoints = [NSMutableArray array];
	}
	return self;
}

- (void)activate
{
    
}

-(void)deleteLastPoint:(BOOL)isDelete
{
    
}

- (void)deactivate
{
	[self.trackingTouches removeAllObjects];
	[self.startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.bAnotherImg)
    {
        return;
    }
	self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuexiao.png"]];
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touchedView];
    self.imgView.center = location;
    [touchedView addSubview:self.imgView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.bAnotherImg)
    {
        return;
    }
    self.bAnotherImg = NO;
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touchedView];
    self.imgView.center = location;
    ImgDrawingInfo *info = [[ImgDrawingInfo alloc] initWithLocation:location andSize:self.imgView.frame.size andImage:self.imgView.image];
    [self.delegate addDrawable:info];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.bAnotherImg)
    {
        return;
    }
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touchedView];
    self.imgView.center = location;
}

- (void)drawTemporary
{
    
}

@end
