//
//  PWSFDetailViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  排污收费

#import "BaseViewController.h"

@interface DefaultDetailViewController : BaseViewController
@property (nonatomic,assign) BOOL showDirectly;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *primaryKey;
@property (nonatomic,strong) UIWebView *webView;

@end
