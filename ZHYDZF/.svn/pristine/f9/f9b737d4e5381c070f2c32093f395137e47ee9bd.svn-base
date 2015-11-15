//
//  PDLargePhotoView.h
//  BoandaProject
//
//  Created by 曾静 on 13-11-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PDLargePhotoView.h"
#import "ASIHTTPRequest.h"
#import "PDFileManager.h"

@interface PDLargePhotoView (private)
- (void)fadeIn;
- (void)fadeOut;
- (void)closeImage:(id)sender;
@end

@implementation PDLargePhotoView
@synthesize parentview;
@synthesize imageBackground, imageBackView, maskView;
@synthesize networkQueue, progress;

-(void)downloadFile
{
    self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    [self addSubview:self.progress];
    
    /*
    service=DOWN_OA_FILES&GLLX=&FJLX=.jpg&BH=20131031194706
     */
    //下载路径
    PDFileManager *pfm = [[PDFileManager alloc] init];
    NSString *docPath = pfm.defaultFolderPath;
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:docPath isDirectory:&isDir])
    {
        [fm createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *path = [docPath stringByAppendingPathComponent:[self.xczfzh lastPathComponent]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
    [params setObject:@"DOWNLOAD_XCQZ_FILE" forKey:@"GLLX"];
    [params setObject:@".jpg" forKey:@"FJLX"];
    [params setObject:self.xczfzh forKey:@"PATH"];//
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    self.attachURL = strURL;

    self.progress.hidden = NO;
    if(!self.networkQueue)
    {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue reset];// 队列清零
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self ]; // 设置队列的代理对象
    ASIHTTPRequest *request;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.attachURL]];
    [request setDownloadProgressDelegate:self.progress]; // 文件 1 的下载进度条
    [request setDownloadDestinationPath:path];
    [request setCompletionBlock :^( void ){
        
        NSData *downData = [NSData dataWithContentsOfFile:path];
        if(downData.length < 2)
        {
            self.image = [UIImage imageNamed:@"default_placehold"];
            imageBackground.image = self.image;
        }
        else
        {
            self.image = [UIImage imageWithContentsOfFile:path];
            imageBackground.image =  self.image;
        }
        // 使用 complete 块，在下载完时做一些事;
       
        self.progress.hidden = YES;
    }];
    [request setFailedBlock :^( void ){
        
        // 使用 failed 块，在下载失败时做一些事情
        self.progress.hidden = YES;
        //TODO：下载失败设置回默认图片
        imageBackground.image = [UIImage imageNamed:@"default_placehold"];
    }];
    [networkQueue addOperation :request];
    [networkQueue go]; // 队列任务开始
}

/*
 * setDoubleTap 初始化图片
 * @parent UIView 父窗口
 */
- (void)setDoubleTap:(UIView*) parent andServiceCode:(NSString *)aCode andWithFileName:(NSString *)aName andWithSatus:(int)st
{
    parentview = parent;
    self.xczfzh = aCode;
    status = st;
    self.attachName = aName;
    parentview.userInteractionEnabled=YES;
    self.userInteractionEnabled=YES;

    UITapGestureRecognizer *doubleTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [self addGestureRecognizer:doubleTapRecognize];
}

#pragma UIGestureRecognizer Handles

/*
 * handleDoubleTap 双击图片弹出单独浏览图片层
 * recognizer 双击手势
 */
-(void) handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
    if (imageBackView == nil)
    {
        if( [[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft||[[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight)
        {
            frameRect = CGRectMake(0, 0, parentview.frame.size.height+20, parentview.frame.size.width);
        }
        else
        {
            frameRect = CGRectMake(0, 0, parentview.frame.size.width, parentview.frame.size.height+20);
        }
        
        imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 730, 900)];
        //imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.image.size.width+20, self.image.size.height+60)];
        imageBackView.backgroundColor = [UIColor grayColor];
        imageBackView.layer.cornerRadius = 10.0; //根据需要调整
        
        [[imageBackView layer] setShadowOffset:CGSizeMake(10, 10)];
        [[imageBackView layer] setShadowRadius:5];
        [[imageBackView layer] setShadowOpacity:0.7];
        [[imageBackView layer] setShadowColor:[UIColor blackColor].CGColor];
        
        maskView = [[UIView alloc]initWithFrame:frameRect];
        maskView.backgroundColor = [UIColor grayColor];
        maskView.alpha=0.7;
        
        UIImage *imagepic = self.image;
        imageBackground= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 710, 880)];
        [imageBackground setImage:imagepic];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *closeimg = [UIImage imageNamed:@"menus_close.png"];
        btn.frame = CGRectMake(730-25,-5, closeimg.size.width,closeimg.size.height);
        [btn setBackgroundImage:closeimg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageBackView addSubview:imageBackground];
        [parentview addSubview:maskView];
        imageBackView.center= CGPointMake((frameRect.origin.x+frameRect.size.width)/2,(frameRect.origin.y+frameRect.size.height)/2);
        [parentview addSubview:imageBackView];
        [imageBackView addSubview:btn];
        [parentview bringSubviewToFront:imageBackView];
        
        self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progress.hidden = YES;
        self.progress.frame = CGRectMake(0, imageBackView.frame.size.height/2, imageBackView.frame.size.width, 10);
        [imageBackView addSubview:self.progress];
        
        [self fadeIn];
    }
}

-(void)fadeIn
{
    //图片渐入动画
    imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    imageBackView.alpha = 0;
    [UIView animateWithDuration:.55 animations:^{
        imageBackView.alpha = 1;
        imageBackView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    if(self.xczfzh.length > 0 && status == 0)
    {
        [self downloadFile];
    }
    
}

//fadeOut 图片逐渐消失动画
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        imageBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imageBackView removeFromSuperview];
        }
    }];
}

//closeImage 关闭弹出图片层
-(void)closeImage:(id)sender
{
    [self fadeOut];
    imageBackView=nil;
    [maskView removeFromSuperview];
    maskView=nil;
}

@end
