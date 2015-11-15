//
//  ListViewController.h
//  BoandaProject
//
//  Created by 熊熙 on 13-12-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ListViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *pkmcField;
@property (strong, nonatomic) IBOutlet UITextField *pklxField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
