//
//  ZFTZListViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"

//TODO:搜索功能还没有完成
@interface ZFTZListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,PopupDateDelegate,WordsDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UITextField *kssjField;
@property (strong, nonatomic) IBOutlet UITextField *jssjField;
@property (strong, nonatomic) IBOutlet UITextField *zflxField;
@property (strong, nonatomic) IBOutlet UITextField *wyrmcField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end
