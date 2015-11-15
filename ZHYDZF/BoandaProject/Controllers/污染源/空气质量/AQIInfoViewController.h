//
//  AQIInfoViewController.h
//  BoandaProject
//
//  Created by BOBO on 14-1-16.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDateViewController.h"
#import "S7GraphView.h"
#import "BaseViewController.h"
#import "ChooseTimeRangeVC.h"
#import "CommenWordsViewController.h"

@interface AQIInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,S7GraphViewDataSource,ChooseTimeRangeDelegate,WordsDelegate>
@property (nonatomic,strong)NSString *IDStr;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSMutableArray *pwkNameAry;
@property (nonatomic,strong)NSArray *IDArray;
@end
