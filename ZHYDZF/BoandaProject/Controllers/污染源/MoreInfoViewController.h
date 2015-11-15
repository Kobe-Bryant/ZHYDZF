//
//  MoreInfoViewController.h
//  BoandaProject
//
//  Created by BOBO on 13-12-19.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDateViewController.h"
#import "S7GraphView.h"
#import "BaseViewController.h"
#import "ChooseTimeRangeVC.h"
#import "CommenWordsViewController.h"

@interface MoreInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,S7GraphViewDataSource,ChooseTimeRangeDelegate>
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSString *pwkId;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)NSString *onejcdwmc;
@property (nonatomic,strong)NSString *IDStr;
@property (nonatomic,strong)NSString *keyString;    //污染因子名称，用于在字典中查找标准数值
@property (nonatomic,strong)NSString *standValue;   //当前污染因子对应的标准值
@property (nonatomic,assign)BOOL hasStandValue;     //污染源是否有标准值
@property (nonatomic,strong)NSMutableArray *tmpArray;       //
@end
