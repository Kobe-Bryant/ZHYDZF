//
//  ZFTZMainRecordViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"

@interface ZFTZMainRecordViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *wrymc;
@property (nonatomic, copy) NSString *primaryKey;

@end
