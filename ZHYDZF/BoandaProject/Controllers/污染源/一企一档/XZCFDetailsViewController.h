//
//  XZCFDetailsViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  行政处罚

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface XZCFDetailsViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *primaryKey;
@property (nonatomic,strong) UIWebView *webView;

@end
