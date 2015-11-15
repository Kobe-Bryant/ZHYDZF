//
//  LiveViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-6-19.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "LiveViewController.h"
#import "VideoPlaySDK.h"
#import "VideoPlayInfo.h"

// 状态回调函数
void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl);
void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl)
{
    NSLog(@"playState is %d", playState);
}
@interface LiveViewController ()
{
    VP_HANDLE _vpHandle;
}
@property (nonatomic, strong) IBOutlet UIView *playView;
@property (nonatomic, strong) VideoPlayInfo *videoPlayInfo;

@end

@implementation LiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"视频监控";
    [self startPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPlay
{
    if (self.videoPlayInfo == nil)
    {
        self.videoPlayInfo = [[VideoPlayInfo alloc] init];
    }
    
    self.videoPlayInfo.strUser   = @"admin";
    self.videoPlayInfo.strPsw    = @"12345";
    self.videoPlayInfo.strPlayUrl    = self.rtspUrl;
    self.videoPlayInfo.protocalType  = PROTOCAL_TCP;
    self.videoPlayInfo.playType      = REAL_PLAY;
    self.videoPlayInfo.streamMethod  = STREAM_METHOD_VTDU;
    self.videoPlayInfo.streamType    = STREAM_SUB;
    self.videoPlayInfo.pPlayHandle   = (id)self.playView;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       if (_vpHandle != NULL)
                       {
                           VP_Logout(_vpHandle);
                           _vpHandle = NULL;
                       }
                       
                       // 获取VideoPlaySDK 播放句柄
                       if (_vpHandle == NULL)
                       {
                           _vpHandle = VP_Login(self.videoPlayInfo);
                       }
                       
                       // 设置状态回调
                       if (_vpHandle != NULL)
                       {
                           VP_SetStatusCallBack(_vpHandle, StatusCallBack, (__bridge void *)self);
                       }
                       
                       // 开始实时预览
                       if (_vpHandle != NULL)
                       {
                           if (!VP_RealPlay(_vpHandle))
                           {
                               NSLog(@"start VP_RealPlay failed");
                           }
                       }
                   });
}

@end
