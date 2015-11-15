//
//  ZFBLListViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-31.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"

#define kServiceName @"WORKFLOW_RECORD_LIST"

@interface ZFBLListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSString *XCZFBH;
@property (nonatomic, strong) NSString *RECORDNAME;
@property (nonatomic, strong) NSString *MBBH;
@property (nonatomic, strong) NSArray *JBXX;

//service=WORKFLOW_RECORD_LIST&XCZFBH=2013103021283003ec2d489cb0487281bdaff30918d40f&RECORD_NAME=现场勘察笔录

@end
