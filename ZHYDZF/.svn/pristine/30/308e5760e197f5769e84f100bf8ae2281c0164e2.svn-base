//
//  PDLargePhotoView.h
//  BoandaProject
//
//  Created by 曾静 on 13-11-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "ASINetworkQueue.h"

@interface PDLargePhotoView : UIImageView
{
    UIView *parentview;//父窗口，即用将UIImageEx所加到的UIView
    UIImageView *imageBackground; //放大图片后的背景
    UIView* imageBackView;//单独查看时的背景
    UIView* maskView;//遮罩层
    CGRect frameRect;
    int status;
}

@property (nonatomic, strong) ASINetworkQueue * networkQueue ;
@property (nonatomic, strong) NSString *attachURL;
@property (nonatomic, strong) NSString *attachName;
@property (nonatomic, strong) NSString *xczfzh;
@property (nonatomic, strong) UIView *parentview;
@property (nonatomic, strong) UIImageView *imageBackground;
@property (nonatomic, strong) UIView* imageBackView;
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, strong) UIProgressView *progress;

- (void)downloadFile;
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;
- (void)setDoubleTap:(UIView*) parent andServiceCode:(NSString *)aCode andWithFileName:(NSString *)aName andWithSatus:(int)st;

@end
