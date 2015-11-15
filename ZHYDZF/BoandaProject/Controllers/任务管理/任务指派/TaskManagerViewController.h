//
//  TaskManagerViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupDateViewController.h"

#define kServiceTag_UndoTaskList_Action 0 //未结束
#define kServiceTag_DoneTaskList_Action 1 //已结束

@interface TaskManagerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PopupDateDelegate>
@property (strong, nonatomic) IBOutlet UITextField *dwmcField;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) IBOutlet UITextField *kssjField;
@property (strong, nonatomic) IBOutlet UITextField *jssjField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end
